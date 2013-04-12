require "rubygems"
require 'fileutils'
require 'utils/general'

conf_file = "conf/run_ldap.properties"
properties = GeneralUtils.LoadProperties(conf_file)

logfilename = properties["logfile"]

$OUTPUT_PATH = properties["output_path"]
$LOG =  Logger.new(STDOUT)
if logfilename.nil?
  $LOG =  Logger.new(STDOUT)
else
  
  
  if !File.exist?(logfilename)
    GeneralUtils.CheckDir(File.dirname(logfilename))
    FileUtils.touch(logfilename)
  end
  $LOG =  Logger.new(logfilename.to_s)
end
$LOG.level=Logger::DEBUG
