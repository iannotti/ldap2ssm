# -*- encoding: utf-8 -*-
require 'ldap2ssm/version'



Gem::Specification.new do |mygem|
  mygem.name          = "ldap2ssm"
  mygem.version       = Ldap2ssm::VERSION
  mygem.authors       = ["Laura Iannotti"]
  mygem.email         = ["laura.iannotti@to.infn.it"]
  mygem.description   = %q{Performs some ldap commands}
  mygem.summary       = %q{summary}
  mygem.homepage      = ""

  mygem.files = Dir['lib/**/*.rb'] + Dir['bin/*'] +Dir['conf/*']
  mygem.bindir        = 'bin'
  mygem.executables   = mygem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  mygem.test_files    = mygem.files.grep(%r{^(test|spec|features)/})
  
  mygem.require_paths  =["lib","conf"]
  
   
  mygem.has_rdoc      = true
  
  mygem.add_dependency "net-ldap"
  mygem.add_dependency "builder"
 
end
