require "rubygems"
require "time"
require "common/constants"

 
class GeneralUtils
  def to_array(h)
    return h unless h.is_a? Hash
    h.each do |k,v|
    puts "hhhhh #{k} .... #{v}"
    h[k] = to_array(v)
    puts "dopo"
  end
    
  end
      
    def GeneralUtils.GetIdFromSeq
      GeneralUtils.CheckDir(ProgramArgs.DataDir)
      if File.exist?(ProgramArgs.SequenceFile)
        file = File.new(ProgramArgs.SequenceFile, "r+") 
        seq = file.gets.to_i        
        if seq.nil? 
          seq = 0
          $LOG.warn("The file #{ProgramArgs.SequenceFile} is empty! "+
                                  "starting recordId from 1")
        end
        
        seq += 1
        $LOG.info("seq: #{seq}")
        file.rewind
        file.puts(seq)
        file.close
      else 
        $LOG.warn("File #{ProgramArgs.SequenceFile} not found !!! "+
          "starting recordId from 1")
        file = File.new(ProgramArgs.SequenceFile, "w+")
        seq = 0
        file.puts(seq)
        file.close
      end  
        seq 
    end
    
    def GeneralUtils.LoadProperties(properties_filename)
        properties = {}
           File.open(properties_filename, 'r') do |properties_file|
             properties_file.read.each_line do |line|
               line.strip!
               if (line[0] != ?# and line[0] != ?=)
                 i = line.index('=')
                 if (i)
                   properties[line[0..i - 1].strip] = line[i + 1..-1].strip
                 else
                  properties[line] = ''
                 end
               end
             end
           end
           properties
     end
    def GeneralUtils.RandomExa(length=8)
        chars = 'abcdef0123456789'
        rnd_str = ''
        length.times { rnd_str << chars[rand(chars.size)] }
        rnd_str
    end
   def GeneralUtils.CheckDir(dirName)
    allSubDirs = nil
    subDirs = ""
    if dirName.slice(0,1) == File::SEPARATOR
      subDirs << File::SEPARATOR
      iSize = dirName.size
      substr = dirName.slice(1,iSize)
      allSubDirs=substr.split(File::SEPARATOR)
     else
      allSubDirs=dirName.split(File::SEPARATOR)
     end
     
     allSubDirs.each do |dir|
       subDirs << dir
       Dir.mkdir(subDirs) unless File.exists?(subDirs)
       subDirs << File::SEPARATOR
     end

  end

 end
 #
 # 
 # 
 class StartEndTimeUtils
      def StartEndTimeUtils.GetStartTime(voName)
        fileName = StartEndTimeUtils.MakeFileName(voName)
        $LOG.info("Time File: "+fileName)
        if File.exist?(fileName) 
          file = File.new(fileName,"r")
        
          startTime = file.gets.chomp
        
          if startTime.nil?
            startTime = Time.now.utc.iso8601
          end
        
          file.close
        else
          startTime = Time.now.utc.iso8601
        end
        startTime
      end
      
      def StartEndTimeUtils.WriteNextStartTime(voName,value)
        fileName = StartEndTimeUtils.MakeFileName(voName)
        $LOG.info("Output Time File: "+fileName)
        file = File.new(fileName,"w+")
        file.puts(value)
        file.close
      end
      
      private
      def StartEndTimeUtils.MakeFileName(voName)
        fileName = ProgramArgs.DataDir+ File::SEPARATOR + voName +"_" +ProgramArgs.TimeFileName
      end
 end  
 
