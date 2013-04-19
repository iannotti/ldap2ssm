require "rubygems"
require 'fileutils'
require 'utils/general'

conf_file = "conf/ldap2ssm.properties"
properties = GeneralUtils.LoadProperties(conf_file)
logfilename = properties["logfile"]
$SITES_FILE = properties["sitelist_file"]
$TOP_BDII = properties["top_bdii"]
$MAX_FILERECORDS=properties["max_records_per_file"]
$MAX_DIRFILES=properties["max_files_per_dir"]
  
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

if $TOP_BDII.nil?
  raise Exception => "The top bdii site address must be provided, check the #{conf_file} file"
end
#
# @todo check the defauld values of MAX_FILERECORDS and MAX_DIRFILES with APEL team
# 
if $MAX_FILERECORDS.nil?
  $MAX_FILERECORDS = 1000
end
if $MAX_DIRFILES.nil?
  $MAX_DIRFILES = 100
end

