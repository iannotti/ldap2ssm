require "rubygems"

require "common/constants"
require "utils/general"
require "utils/senddata"
require "search/ldap_queries"

module Search
  class ManageSearch
    def initialize
      @fileXml = WriteXmlFile.new
    end
    
    def queries
      siteList = GeneralUtils.LoadCleanFileData($SITES_FILE)
      siteList.each do |site|
        querySite = ManageQueries.new($TOP_BDII,site)
        allRecords = querySite.getGlueOneInfo
        if !allRecords.nil? && allRecords.size != 0
          writeFile($MAX_FILERECORDS.to_i, allRecords)
        end
        allRecords = nil
        querySite = nil
      end
      
    end
    
    private 
    def writeFile(iMaxSize, allRecords)
      if allRecords.size > iMaxSize
        iCount = 0
        recordTmp = {}
        recordKeys = Array.new
        recordTmp.each do |key,value|
          recordTmp[key] = value
          iCount += 1
          if iCount >= iMax
            @fileXml.writeFile($MAX_DIRFILES,recordTmp)
            iCount = 0
            recordTmp = nil
          end 
        end
      if !recordTmp.nil?
        @fileXml.writeFile($MAX_DIRFILES,allRecords)
      end
       
    else
      @fileXml.writeFile($MAX_DIRFILES,allRecords)
     end
      
    end
  end
end
