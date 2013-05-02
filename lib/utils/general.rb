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
      
     
    def GeneralUtils.LoadProperties(properties_filename)
        properties = {}
          if !File.exist?(properties_filename)
            $LOG.error("The file #{properties_filename} does'nt exist!! ")
            return properties
          end
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
     #
     # get the data from a file removing all the lines and the strings after # character
     #
     def GeneralUtils.LoadCleanFileData(fileName)
       data = Array.new
       iLines = 0
       if File.exist?(fileName)
        File.open(fileName, 'r') do |lines|
          lines.read.each_line do |line|
            line.strip!
            if (line[0] != ?# )
              i = line.index('#')
              if (i)
                data << line[0..i - 1].strip
              else
                data << line
              end
            end
          end
         end
       else
        msg = "File #{fileName} not found !!! "+
              "you have to provide it to run the program!!! "
        $LOG.error(msg)
        raise Exception, msg
      end
      data   
     end
       
     
    def GeneralUtils.RandomExa(length, chars = 'abcdef0123456789')
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
  
 
