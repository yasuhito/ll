require "hanna/rdoctask"


Rake::RDocTask.new do | t |
  t.main = "README.rdoc"
  t.rdoc_files.include "README.rdoc", "lib/**/*.rb"
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
