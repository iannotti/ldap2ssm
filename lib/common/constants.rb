require "rubygems"

  
  class SRecords
  
  # hash with the elements in star format to include in the xml file
  # format (from StAR-EMI-tech-doc-v7.doc)
  # <sr:StorageUsageRecords>
  # <sr:StorageUsageRecord>
  # <!—Record properties go in here -->
  # </sr:StorageUsageRecord>
  # <sr:StorageUsageRecord>
  # <!—Record properties go in here -->
  # </sr:StorageUsageRecord>
  # </sr:StorageUsageRecords>
  # 
  # <sr:Site>ACME-University</sr:Site>
  # Glue 1.3 => GlueSiteName
  # Glue 2.0 => StorageShareAdminDomain
  #
  # <sr:RecordIdentity                
  # sr:createTime="2010-11-09T09:06:52Z"
  # sr:recordId="host.example.org/sr/87912469269276"/>
  #
  # <sr:StorageSystem>host.example.org</sr:StorageSystem>
  # glue 1.3 --> GlueSEUniqueID
  # glue 2.0 --> StorageShareID
  # 
  #
  # <sr:StorageMedia>disk</sr:StorageMedia>
  # Glue 1.3 --> disk if Online
  #          --> tape if Nearline
  # Glue 2.0 --> Type
  # if the ldapsearch command returns GlueSA*NearlineSize != 0 e  GlueSA*OnlineSize == 0
  # sr:StorageMedia is tape
  # if the ldapsearch command returns GlueSA*NearlineSize == 0 e  GlueSA*OnlineSize != 0
  # sr:StorageMedia is disk
  #
  # <sr:StorageClass>permanent</sr:StorageClass> 
  # Glue 1.3 --> GlueSAType 
  # Glue 2.0 --> StorageShareOtherInfo
  # 
  # <sr:FileCount>42</sr:FileCount>
  # number of files accounted by VO and Site
  # this information is not available from glue
  # 
  # <sr:DirectoryPath>/projectA</sr:DirectoryPath>
  # Glue 1.3 --> VOInfoPath
  # Glue 2.0 --> StorageShareLocalPath
  #
  # <sr:SubjectIdentity> 
  #     <!-- Various identity fields go in here -->
  #     <sr:Group>binarydataproject.example.org</sr:Group>
  # </sr:SubjectIdentity>
  #
  # <sr:StartTime>2010-10-11T09:31:40Z</sr:StartTime>
  #  this is set to the end time of the most recent record for the VO
  #
  # <sr:ResourceCapacityUsed>14728</sr:ResourceCapacityUsed>
  # Glue 1.3 --> GlueSAUsedOnlineSize
  # Glue 2.0 --> StorageShareUsedSize
  # 
  # <sr:ResourceCapacityAllocated>14624</sr:ResourceCapacityAllocated>
  # Glue 1.3 --> GlueSATotalOnlineSize or GlueSAFreeOnlineSize or GlueSAReservedOnlineSize
  #
  # <sr:StorageShare>pool-003</sr:StorageShare>
  # Glue 1.3 --> GlueSALocalID
  # Glue 2.0 --> StorageShareName
  #
  
  
    @@Separator = ":"
    @@Prefix = "sr"
    @@Storageurs_key  =  @@Prefix + @@Separator + "StorageUsageRecords"
    @@Storageur_key = @@Prefix + @@Separator + "StorageUsageRecord"
    @@RI_field_key = @@Prefix + @@Separator + "RecordIdentity"                         # sr:RecordIdentity
    @@RI_createtime_key = @@Prefix + @@Separator + "createTime"                        # sr:createTime
    @@Recordid_key = @@Prefix + @@Separator + "recordId"                               # sr:recordId
    @@Storagesystem_key = @@Prefix + @@Separator + "StorageSystem"                     # sr:StorageSystem
    @@Storageshare_key = @@Prefix + @@Separator + "StorageShare"                       # sr:StorageShare
    @@Storagemedia_key = @@Prefix + @@Separator + "StorageMedia"                       # sr:StorageMedia
    @@Storageclass_key = @@Prefix + @@Separator + "StorageClass"                       # sr:StorageClass
    @@Filecount_key = @@Prefix + @@Separator + "FileCount"                             # sr:FileCount
    @@Directorypath_key = @@Prefix + @@Separator + "DirectoryPath"                     # sr:DirectoryPath
    @@Subjectidentity_key = @@Prefix + @@Separator + "SubjectIdentity"                 # sr:SubjectIdentity
    @@Group_key = @@Prefix + @@Separator + "Group"                                     # sr:SubjectIdentity
    @@Starttime_key = @@Prefix + @@Separator + "StartTime"                             # sr:StartTime
    @@Endtime_key = @@Prefix + @@Separator + "EndTime"                                 # sr:EndTime
    @@Resourcecapacityused_key = @@Prefix + @@Separator + "ResourceCapacityUsed"       # sr:ResourceCapacityUsed
    @@Resourcecapacityalloc_key = @@Prefix + @@Separator + "ResourceCapacityAllocated" # sr:ResourceCapacityAllocated
    @@Site_key = @@Prefix + @@Separator + "Site"                                       # sr:Site
    
    def SRecords.Prefix
      @@Prefix
    end
    def SRecords.StorageUsageRecords
      @@Storageurs_key
    end
    
    def SRecords.StorageUsageRecord
      @@Storageur_key 
    end
    def SRecords.RecordIdentity
      @@RI_field_key
    end
    def SRecords.CreateTime
      @@RI_createtime_key
    end
    def SRecords.RecordId
      @@Recordid_key
    end
    def SRecords.StorageSystem
      @@Storagesystem_key
    end
    def SRecords.StorageMedia
      @@Storagemedia_key
    end
    def SRecords.StorageClass
       @@Storageclass_key
     end
    def SRecords.StorageShare
       @@Storageshare_key
     end
    def SRecords.StorageClass
      @@Storageclass_key
    end
    def SRecords.FileCount
      @@Filecount_key
    end
    def SRecords.DirectoryPath
      @@Directorypath_key
    end
    def SRecords.SubjectIdentity
      @@Subjectidentity_key
    end
    def SRecords.Group
      @@Group_key
    end
    def SRecords.StartTime
      @@Starttime_key
    end
    def SRecords.EndTime
      @@Endtime_key
    end
    def SRecords.ResourceCapacityUsed
      @@Resourcecapacityused_key
    end    
    def SRecords.Resourcecapacityalloc
      @@Resourcecapacityalloc_key
    end 
    def SRecords.Site
      @@Site_key
    end
  end
  
  class GlueOneRecords
    
    @@GlueSiteName = "GlueSiteName"
    @@GlueSAAccessControlBaseRule = "GlueSAAccessControlBaseRule"
    @@GlueSATotalNearlineSize = "GlueSATotalNearlineSize"   # to use to determine the the storage Media
    @@GlueSATotalOnlineSize = "GlueSATotalOnlineSize"       # to use to determine the the storage Media
    @@GlueSEUniqueID = "GlueSEUniqueID"                     # to extract from the dn
    @@GlueVOInfoPath = "GlueVOInfoPath" 
    @@GlueSAType = "GlueSAType"
    #@TODO remove GlueVOInfoTag after check with Andrea C.
    @@GlueVOInfoTag = "GlueVOInfoTag"
    @@GlueSALocalID = "GlueSALocalID"
    # I neglect (for thr moment) the Nearline media !!! 
    @@GlueSAUsedOnlineSize = "GlueSAUsedOnlineSize"
    @@GlueSATotalOnlineSize = "GlueSATotalOnlineSize"
    @@GlueSAUsedNearlineSize = "GlueSAUsedNearlineSize"
    @@GlueSATotalNearlineSize = "GlueSATotalNearlineSize"
    @@StorageTape = "tape"
    @@StorageDisk = "disk"

    def GlueOneRecords.GlueSAAccessControlBaseRule
      @@GlueSAAccessControlBaseRule
    end
    def GlueOneRecords.GlueSATotalNearlineSize
      @@GlueSATotalNearlineSize
    end
    def GlueOneRecords.GlueSATotalOnlineSize
      @@GlueSATotalOnlineSize
    end
    def GlueOneRecords.GlueSEUniqueID
      @@GlueSEUniqueID
    end
    def GlueOneRecords.GlueVOInfoPath
      @@GlueVOInfoPath
    end
    def GlueOneRecords.GlueVOInfoTag
      @@GlueVOInfoTag
    end
    def GlueOneRecords.GlueSALocalID
      @@GlueSALocalID
    end
    def GlueOneRecords.GlueSAType
      @@GlueSAType
    end
    def GlueOneRecords.GlueSAUsedOnlineSize
      @@GlueSAUsedOnlineSize
    end
    def GlueOneRecords.GlueSATotalOnlineSize
      @@GlueSATotalOnlineSize
    end
    def GlueOneRecords.GlueSAUsedNearlineSize
       @@GlueSAUsedNearlineSize
     end
     def GlueOneRecords.GlueSATotalNearlineSize
       @@GlueSATotalNearlineSize
     end

    def GlueOneRecords.GlueSiteName
      @@GlueSiteName
    end
    def GlueOneRecords.StorageTape
        @@StorageTape
    end
    def GlueOneRecords.StorageDisk
        @@StorageDisk
      end
    
    end
    
    class ProgramArgs
      
      @@GenericFileName = "generic"
      
      @@DataDir = "data"
      @@SequenceFile = @@DataDir + File::SEPARATOR + "sequence.dat"
      @@TimeFileName = "time.dat"
      @@MaxRecords = 1000
      @@ConversionFactor = 1024**3
      @@NameSpace = "http://eu-emi.eu/namespaces/2011/02/storagerecord"
      def ProgramArgs.SequenceFile
        @@SequenceFile
      end
      def ProgramArgs.InputPropertyFile
        @@InputPropertyFile
      end
      def ProgramArgs.TimeFileName
         @@TimeFileName
       end
      def ProgramArgs.DataDir
          @@DataDir
        end
      def ProgramArgs.NameSpace
        @@NameSpace
      end
      def ProgramArgs.ConversionFactor
        @@ConversionFactor
      end
      def ProgramArgs.GenericFileName
        @@GenericFileName
      end
   end
    
    
 


    


