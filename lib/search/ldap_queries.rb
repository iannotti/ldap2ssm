require "rubygems"
require "net/ldap"
require "ldap2ssm/version"
require "common/constants"
require "data/record"
require "utils/general"
require "utils/starsrrecord"
require "utils/senddata"
require "utils/timeutils"

# host t2-bdii-01.to.infn.it
# port 2170
# root_dir INFN-TORINO
# host_type BDII



 module Search
  
  class ManageQueries
    

    def initialize(host, site)
      port = 2170
      #when initialize the class also open the time file
      @startEndTime = StartEndTime.new(site)
      @siteFound = false
      @treebase = "Mds-Vo-name=#{site},Mds-Vo-name=local,o=grid"
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
           attrs = [GlueOneRecords.GlueSiteName]
           @conn.search(:base => treebase, 
                        :filter => filter, 
                        :attributes => attrs, 
                        :return_result => false) do|entry|
                          @siteFound = true
                          $LOG.debug("DN: #{entry.dn}")
                          entry.send(GlueOneRecords.GlueSiteName).each do |value|
                            @site=value
                          end
                         end
                          
     end
     def getSEInfo
          $LOG.info("getting general SE info")
          storageSystems = []
          filter = Net::LDAP::Filter.eq("objectClass", "GlueSE")
          attrs = [GlueOneRecords.GlueSEUniqueID]
          @conn.search(:base => treebase, 
                       :filter => filter, 
                       :attributes => attrs, 
                       :return_result => false) do|entry|
                         $LOG.debug("DN: #{entry.dn}")
                         entry.send(GlueOneRecords.GlueSEUniqueID).each do |value|
                           storageSystems<<value
                         end                         
                       end
                       storageSystems
    end
#  getGlueSAInfo extracts all the information about the GlueSA objectClass
#  apart 
#
     def getGlueOneInfo
       allRecords = {}
       partialInfoRecords = {}
       
       i = 0
       iMax = 0
       
#extract the info common to all the VO
       getGeneralSiteInfo
       if !@siteFound
         return
       end
       storageSystems = getSEInfo
       $LOG.info("getting Glue-One info")
 # extract all the information of objectClass GlueSA
         filter = Net::LDAP::Filter.eq("objectClass", "GlueSA")
         attrs = [GlueOneRecords.GlueSATotalOnlineSize,
                  GlueOneRecords.GlueSATotalNearlineSize,
                  GlueOneRecords.GlueSAAccessControlBaseRule,
                  GlueOneRecords.GlueSAType,
                  GlueOneRecords.GlueSAUsedOnlineSize,
                  GlueOneRecords.GlueSATotalOnlineSize,
                  GlueOneRecords.GlueSAUsedNearlineSize,
                  GlueOneRecords.GlueSATotalNearlineSize,
                  GlueOneRecords.GlueSALocalID]
         storageSystems.each do |storageSystem|
           newBase = GlueOneRecords.GlueSEUniqueID+"=#{storageSystem},"+@treebase
           @conn.search(:base => newBase,
                              :filter => filter, 
                              :attributes => attrs, 
                               :return_result => false)  do|entry|
                                begin
                                  partialInfoRecords[entry.dn] = decodeData(storageSystem, entry)
                                rescue Exception
                                 next
                                end
                               end
          end #loop on storageSystem
#                               
# extract the GlueVOInfoPath using the dn as base directory
#                                          
          attrs = [GlueOneRecords.GlueVOInfoPath]
          filter = Net::LDAP::Filter.eq("objectClass", "*")
          partialInfoRecords.each do |key,record|
            insertValue = false
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
                           if insertValue
                             break
                           end 
                         end
            
            end
            
            if insertValue
              record.endTime=Time.now.utc.iso8601
              allRecords[i] = record
              i += 1
              insertValue = false
            end
            
            
         end
      
                        
 # now get the data of VO
          
          @startEndTime.writeNextStartTimeFile
          allRecords.each do |nkey,nrecord|
           $LOG.debug(nrecord.to_s)
          end
          allRecords
         
       end
       
       private
       def decodeData(storageSystem,entry)
         #first clean the record Data
         $LOG.info("ENTERING decodeData for Storage System #{storageSystem}")
         recordData = SRecordData.new
         
         recordData.site=@site
         
         recordData.recordId=storageSystem
         
         recordData.storageSystem=storageSystem
         
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
           end
         
         entry.send(GlueOneRecords.GlueSAType).each do |value|
           recordData.storageClass=value
         end
         entry.send(GlueOneRecords.GlueSALocalID).each do |value|
           recordData.storageShare=value
         end
         
         # get the startTime values from an external file, if it exists
           # otherwise the startTime is the current time
           #
         groupNameClean = cleanGroupName(recordData.group)
         
         recordData.startTime=@startEndTime.getStartTime(storageSystem, groupNameClean)
         
         recordData
         
 
          
      end
      def cleanGroupName(grName)
        if (grName[0] == ?/)
          grName = grName.slice(1,grName.size)
        end
        
        grClean = grName.split(/\/|:|_|=/).first
      end
      
        

    end
  end

