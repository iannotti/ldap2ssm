require "rubygems"
require "time"

#
# this class contains the utilities to get the start time and the end time
# the start time and end time are read from a file and put in an hash  
#
class StartEndTime
  
  def initialize(site)
    @siteName = site
    readSiteFile
    
  end
  
  def mkKey(storageSystem,group)
    key = group+"**"+storageSystem
  end
  
  def getStartTime(storageSystem,group)
    key = mkKey(storageSystem,group)
    
    value = @startTimeHash[key]
    
    if value.nil?
      
      value = Time.now.utc.iso8601
    end
    addTime(storageSystem,group,value)
    
  end
  # write in the file <site>.dat the starttime for every <se>**<vo>
  def writeNextStartTimeFile
    fileName = makeSiteFileName
    file = File.new(fileName,"w+")
    @startTimeHash.each do |key,value|
      time = Time.now.utc.iso8601
      file.puts("#{key}=" + time)
    end
    file.close()
  end
 
  
  
  private 
  def addTime(storageSystem,group,time)
       
    key = mkKey(storageSystem,group)
    
    @startTimeHash[key]=time 
  
  end
  
  def readSiteFile
  
    fileName = makeSiteFileName
    if File.exist?(fileName)
      @startTimeHash = GeneralUtils.LoadProperties(fileName)
    else
      @startTimeHash = Hash.new
    end
    
    @startTimeHash.default = nil 
    
     
  end
  
  def makeSiteFileName
    GeneralUtils.CheckDir($INPUT_DATA_PATH)
    fileName = $INPUT_DATA_PATH + File::SEPARATOR + "#@siteName.dat"
  end
end #class end
  
