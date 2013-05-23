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
    attr :storageShare 
    attr :endTime
    attr :resourceCapacityUsed
    attr :resourceCapacityAllocated
    
    def initialize
      @site = nil
      @createTime = Time.now.utc.iso8601
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
      @storageShare = nil
 
    end
    def site=(value)
      @site = value
    end
    def recordId=(value)
      @recordId = "#{value}" + "/" + generateId
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
    def storageShare=(value)
      @storageShare = value
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
      @storageShare = nil
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
        "StorageShare: #@storageShare \n"+
        "StartTime: #@startTime \n" +
        "EndTime: #@endTime \n" +
        "ResourceCapacityUsed: #@resourceCapacityUsed \n"+
        "ResourceCapacityAllocated: #@resourceCapacityAllocated \n"
    end
    private
    def generateId
        time = Time.now.to_i
        timeHex = time.to_s(16)
        id = nil
        id = timeHex + GeneralUtils.RandomExa(4,'0123456789ABCDEFGHILMNOPQRSTUVXYZ')
        id

    end

  end
  
