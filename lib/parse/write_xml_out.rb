require "rubygems"
require 'builder'

# The class writes the output in a xml file 

module Xml
  class WriteXml
    
    def initialize
      
    end
    def product_xml
      myfile = File.new("file.xml", "w+")
      xml = Builder::XmlMarkup.new(:target =>myfile, :indent => 3 )
 ##     xml = Builder::XmlMarkup.new( :indent => 3 )
      xml.instruct! :xml, :encoding => "UTF-8"
      xml.comment! "mycomm"
      xml.product do |p|
          p.name("Test", "type"=>"mytype")
        p.name("type" =>"innertype") {
        p.inner "inner"
        } 
           
       end
       myfile.close
        
    
    end
  end
  
end
