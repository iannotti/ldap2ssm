require "rubygems"

  
    
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
    
    
 


    


