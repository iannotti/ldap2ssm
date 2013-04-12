require "rubygems"
require "time"
require "common/constants"
require "utils/general"

  class SRecordData
    attr :site #define getter method
    attr :createTime
    attr :recordId
    attr :storageSystem
    attr :storageMedia
    attr :storageClass
    attr :directoryPath
    attr :group
    attr :startTime
    attr :endTime
    attr :resourceCapacityUsed
    attr :resourceCapacityAllocated
    
    def initialize
      @site = nil
      @createTime = Time.now.utc.iso8601
      id = GeneralUtils.GetIdFromSeq
      @recordIdPostFix = "/sr/"+id.to_s 
      @recordId = nil                      #the recordIdPrefix contains the GlueSEUniqueId
      @storageSystem = nil
      @storageMedia = GlueOneRecords.StorageDisk
      @storageClass = nil
      @directoryPath = nil                 
      @group = nil                            
      @startTime = nil                         
      @endTime = nil                              
      @resourceCapacityUsed = nil       
      @resourceCapacityAllocated = nil
 
    end
    def site=(value)
      @site = value
    end
    def recordId=(value)
      @recordId = value + @recordIdPostFix
    end
    def storageSystem=(value)
       @storageSystem = value
    end
    def storageMedia=(value)
      @storageMedia = value
    end
    def storageClass=(value)
      @storageClass = value
    end
    def directoryPath=(value)
      @directoryPath = value
    end
    def group=(value)
      @group = value
    end
    def startTime=(value)
      @startTime = value
    end
    def endTime=(value)
      @endTime = value
    end
    def resourceCapacityUsed=(value)
      valueBig = value.to_i
      valueTot = valueBig * ProgramArgs.ConversionFactor
      @resourceCapacityUsed = valueTot
    end
    def resourceCapacityAllocated=(value)
      valueBig = value.to_i
      valueTot = valueBig * ProgramArgs.ConversionFactor
     @resourceCapacityAllocated = valueTot
    end 
    
    def cleanVOData
      @storageMedia = GlueOneRecords.StorageDisk
      @resourceCapacityUsed = nil
      @resourceCapacityAllocated = nil 
      @group = nil 
      @storageClass=nil
      @startTime= nil 
      @endTime= nil 
      @directoryPath= nil 
      
    end
    
    def to_s
        "RecordData: \n" + 
        "Site: #@site \n" + 
        "RecordId: #@recordId \n" +
        "CreateTime: #@createTime \n" +
        "StorageSystem: #@storageSystem \n" +
        "StorageMedia: #@storageMedia \n" +
        "StorageClass: #@storageClass \n" +
        "DirectoryPath: #@directoryPath \n"+
        "Group: #@group \n" +
        "StartTime: #@startTime \n" +
        "EndTime: #@endTime \n" +
        "ResourceCapacityUsed: #@resourceCapacityUsed \n"+
        "ResourceCapacityAllocated: #@resourceCapacityAllocated \n"
    end
  end
  
