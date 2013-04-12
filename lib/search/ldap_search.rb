require "rubygems"
require "net/ldap"
require "ldap2ssm/version"
require "common/constants"
require "data/record"
require "utils/general"
require "utils/senddata"

# host t2-bdii-01.to.infn.it
# port 2170
# root_dir INFN-TORINO
# host_type BDII



 module Search
  
  class ManageSearch
    

    def initialize
      host = "t2-bdii-01.to.infn.it"
      port = 2170
      @treebase = "Mds-Vo-name=INFN-TORINO,o=grid"
      @conn = Net::LDAP.new 
      @conn.host = host
      @conn.port = port      
    end
    def treebase
      return @treebase
    end
      def checkConnection
       if @conn.bind
         $LOG.info("The connection is OK") 
       else
         $LOG.info("The connection is NOT OK")
       end
     end
     # Get the information about GlueSiteUniqueID 
     # NOTE: the same object class may be used to get the 
     # GlueSchemaVersionMajor and GlueSchemaVersionMinor
     #
    def getGeneralSiteInfo
           $LOG.info("getting general site info")
           filter = Net::LDAP::Filter.eq("objectClass", "GlueSite")
           attrs = [GlueOneRecords.GlueSiteUniqueID]
           @conn.search(:base => treebase, 
                        :filter => filter, 
                        :attributes => attrs, 
                        :return_result => false) do|entry|
                          $LOG.debug("DN: #{entry.dn}")
                          entry.send(GlueOneRecords.GlueSiteUniqueID).each do |value|
                            @site=value
                          end
                         end
                          
     end
     def getSEInfo
          $LOG.info("getting general SE info")
          filter = Net::LDAP::Filter.eq("objectClass", "GlueSE")
          attrs = [GlueOneRecords.GlueSEUniqueID]
          @conn.search(:base => treebase, 
                       :filter => filter, 
                       :attributes => attrs, 
                       :return_result => false) do|entry|
                         $LOG.debug("DN: #{entry.dn}")
                         entry.send(GlueOneRecords.GlueSEUniqueID).each do |value|
                           @recordId=value
                           @storageSystem=value
                         end                         
                       end
    end
#  getGlueSAInfo extracts all the information about the GlueSA objectClass
#  apart 
#
     def getGlueOneInfo
       allRecords = {}
       @partialInfoRecords = {}
       insertValue = false
       i = 0
       iMax = 0
       fileXml = WriteXmlFile.new
#extract the info common to all the VO
       getGeneralSiteInfo
       getSEInfo
 # extract all the information of objectClass GlueSA
         filter = Net::LDAP::Filter.eq("objectClass", "GlueSA")
         attrs = [GlueOneRecords.GlueSATotalOnlineSize,
                  GlueOneRecords.GlueSATotalNearlineSize,
                  GlueOneRecords.GlueSAAccessControlBaseRule,
                  GlueOneRecords.GlueSAType,
                  GlueOneRecords.GlueSAUsedOnlineSize,
                  GlueOneRecords.GlueSATotalOnlineSize,
                  GlueOneRecords.GlueSAUsedNearlineSize,
                  GlueOneRecords.GlueSATotalNearlineSize]
         @conn.search(:base => @treebase, 
                              :filter => filter, 
                              :attributes => attrs, 
                               :return_result => false)  do|entry|
                                begin
                                 decodeData(entry)
                                rescue Exception
                                 next
                                end
                               end
#                               
# extract the GlueVOInfoPath using the dn as base directory
#                                          
          attrs = [GlueOneRecords.GlueVOInfoPath]
          filter = Net::LDAP::Filter.eq("objectClass", "*")
          @partialInfoRecords.each do |key,record|
            @conn.search(:base => key.to_s, 
                         :filter => filter,
                         :attributes => attrs, 
                         :return_result => false)  do |entry|
                         $LOG.debug("DN: #{entry.dn}")
                         entry.each do |attr, values|
                          if attr.to_s.casecmp(GlueOneRecords.GlueVOInfoPath) == 0
                            values.each do |value|
                              record.directoryPath=value
                              insertValue=true
                            end
                          end
                         end
                         if insertValue
                           timeNow = Time.now.utc.iso8601
                           record.endTime=timeNow
                           StartEndTimeUtils.WriteNextStartTime(record.group,timeNow)
                           allRecords[i] = record
                           i += 1
                           insertValue = false
# if we get more than MaxRecords, write them to the file and restast the hash
                           if i >= ProgramArgs.MaxRecords
                             fileXml.writeFile(iMax,allRecords)
                             allRecords = nil
                             i = 0
                           end
                         end
            
            end
          end
          if !allRecords.nil?
            fileXml.writeFile(iMax,allRecords)
          end
      
                        
 # now get the data of VO
          
          
          allRecords.each do |nkey,nrecord|
           $LOG.debug(nrecord.to_s)
          end
         
       end
       
       private
       def decodeData(entry)
         #first clean the record Data
         recordData = SRecordData.new
         recordData.site=@site
         recordData.recordId=@recordId
         recordData.storageSystem=@storageSystem
         
         satotalonlinesize = 0
         satotalnearlinesize = 0
         $LOG.debug("DN: #{entry.dn}") 
           entry.send(GlueOneRecords.GlueSATotalOnlineSize).each do |value|
             satotalonlinesize = value
           end
           entry.send(GlueOneRecords.GlueSATotalNearlineSize) do |value|
             satotalnearlinesize = value
           end

           # StorageMedia: I leave the default value (disk) 
           # 1) if online size and nearline size are both 0 
           # 
           
           if(satotalnearlinesize != 0 && satotalonlinesize == 0)
             recordData.storageMedia=GlueOneRecords.StorageTape
           elsif(satotalnearlinesize == 0 && satotalonlinesize != 0)
             recordData.storageMedia=GlueOneRecords.StorageDisk
           end
           # get ResourceCapacityUsed and ResourceCapacityAllocated for disk or tape
           # 
           if recordData.storageMedia == GlueOneRecords.StorageTape
             entry.send(GlueOneRecords.GlueSAUsedNearlineSize).each do |value|
               recordData.resourceCapacityUsed = value
             end
             entry.send(GlueOneRecords.GlueSATotalNearlineSize).each do |value|
               recordData.resourceCapacityAllocated = value
             end
             
           elsif recordData.storageMedia == GlueOneRecords.StorageDisk
             entry.send(GlueOneRecords.GlueSAUsedOnlineSize).each do |value|
               recordData.resourceCapacityUsed = value
             end
             entry.send(GlueOneRecords.GlueSATotalOnlineSize).each do |value|
               recordData.resourceCapacityAllocated = value
             end
           else
             raise Excepion=>"value not allowed for storage Media"
           end
           
           # get Group value
          entry.send(GlueOneRecords.GlueSAAccessControlBaseRule).each do |value|
           # take only last value after latest : separator
            iFirst = value.to_s.rindex(':')+1
            iLast = value.to_s.size
            groupStr = value.to_s.slice(iFirst,iLast)
            recordData.group = groupStr
            # get the startTime values from an external file, if it exists
             # otherwise the startTime is the current time
             #
            recordData.startTime=StartEndTimeUtils.GetStartTime(groupStr)
          end
         entry.send(GlueOneRecords.GlueSAType).each do |value|
           recordData.storageClass=value
         end
         @partialInfoRecords[entry.dn] = recordData
 
          
      end

    end
    
  end

