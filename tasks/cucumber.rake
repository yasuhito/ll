require "cucumber/rake/task"


Cucumber::Rake::Task.new do | t |
  rm_f $rcov_dat
  t.rcov = true
  t.rcov_opts = $rcov_opts
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
