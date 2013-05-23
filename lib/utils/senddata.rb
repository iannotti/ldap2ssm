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
          if record.storageShare != nil
            ur.tag!(SRecords.StorageShare, record.storageShare)
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
    
    localOutputPath = $LOCAL_OUTPUT_PATH
    if !localOutputPath.nil?
      copyFiles
    end
      
    
  end
  
  private
  
  def buildFileName
    fileName = generateDir($OUTPUT_PATH) + generateFileName
  end
  #
  # @TODO to generate a new directory if there are more than 100 files
  #
  def generateDir(path)
    GeneralUtils.CheckDir(path)
    dirPath = path + File::SEPARATOR
    
    
  end
# generate the file name using the naming schema 
# reported to the address https://wiki.egi.eu/wiki/APEL/SSM2AddingFiles
# for the microsecond side we use a random nimber

  def generateFileName
    time = Time.now.to_i
    timeHex = time.to_s(16)
    random_string = GeneralUtils.RandomExa(6)
    filename = timeHex + random_string
    filename

  end
  def copyFiles
    path_out = generateDir($LOCAL_OUTPUT_PATH)
    path_in = generateDir($OUTPUT_PATH)
    Dir.foreach($OUTPUT_PATH) do |item|
      next if item == '.' or item == '..'
      FileUtils.copy_file(path_in + item, path_out + item)
    end
  end
    
end