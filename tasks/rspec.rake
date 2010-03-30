require "spec/rake/spectask"


desc "Run specs with RCov"
Spec::Rake::SpecTask.new do | t |
  t.spec_files = FileList[ "spec/**/*_spec.rb" ]
  t.spec_opts = [ "--color", "--format", "nested" ]
  t.rcov = true
  t.rcov_opts = $rcov_opts
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
