# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ldap2ssm/version'



Gem::Specification.new do |mygem|
  mygem.name          = "ldap2ssm"
  mygem.version       = RubyLdap::VERSION
  mygem.authors       = ["Laura Iannotti"]
  mygem.email         = ["laura.iannotti@to.infn.it"]
  mygem.description   = %q{Performs some ldap commands}
  mygem.summary       = %q{summary}
  mygem.homepage      = ""

  mygem.files = Dir['lib/**/*.rb'] + Dir['bin/*'] 
  mygem.bindir        = 'bin'
  mygem.executables   = mygem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  mygem.test_files    = mygem.files.grep(%r{^(test|spec|features)/})
  mygem.require_path  = ["lib"]
  
  mygem.has_rdoc      = true
  
  mygem.add_dependency "net-ldap"
  
end
