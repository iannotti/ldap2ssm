require "rubygems"
require 'fileutils'
require "builder"
require "common/constants"

class WriteXmlFile
  attr :fileName
  
  def initialize
    fileName = ""
  end
  
  def writeFile(fileNum, records)
    fileName = buildFileName
    
    xmlFile = File.new(fileName, "w+")
    xmlData = Builder::XmlMarkup.new(:target =>xmlFile, :indent => 3 )
    
##    xmlData = Builder::XmlMarkup.new( :target =>STDOUT, :indent => 3 )
    xmlData.instruct! :xml, :encoding => "UTF-8"
    
    xmlData.tag!(SRecords.StorageUsageRecords, 
      {"xmlns:#{SRecords.Prefix}"=>ProgramArgs.NameSpace}) do |urs|
        records.each do |key,record| 
        urs.tag!(SRecords.StorageUsageRecord) do |ur|
          ur.tag!(SRecords.RecordIdentity,{SRecords.CreateTime => "#{record.createTime}",
                  SRecords.RecordId => "#{record.recordId}"})
          ur.tag!(SRecords.Site, record.site)
          ur.tag!(SRecords.SubjectIdentity) do |si|
            si.tag!(SRecords.Group, record.group)
          end
          ur.tag!(SRecords.StorageMedia, record.storageMedia)
          ur.tag!(SRecords.StorageClass, record.storageClass)
          ur.tag!(SRecords.DirectoryPath,record.directoryPath)
          ur.tag!(SRecords.ResourceCapacityUsed, record.resourceCapacityUsed)
          ur.tag!(SRecords.Resourcecapacityalloc, record.resourceCapacityAllocated)
          ur.tag!(SRecords.StartTime,record.startTime)
          ur.tag!(SRecords.EndTime,record.endTime)
          ur.tag!(SRecords.StorageSystem,record.storageSystem)
          
        end
        end
    end
    
    xmlFile.close
    
  end
  
  private
  
  def buildFileName
    fileName = generateDir + generateFileName
  end
  #
  # @TODO to generate a new directory if there are more than 100 files
  #
  def generateDir
    GeneralUtils.CheckDir($OUTPUT_PATH)
    dirPath = $OUTPUT_PATH + File::SEPARATOR
    
    
  end
# generate the file name using the naming schema 
# reported to the address https://wiki.egi.eu/wiki/APEL/SSM2AddingFiles
# for the microsecond side we use a random nimber

  def generateFileName
    time = Time.now.to_i
    timeHex = time.to_s(16)
    random_string = GeneralUtils.RandomExa(6)
    filename = timeHex + GeneralUtils.RandomExa(6)
    filename

  end
end