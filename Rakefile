require "cucumber/rake/task"
require "rake/clean"
require "spec/rake/spectask"
require "spec/rake/verify_rcov"


Dir[ "tasks/**/*.rake" ].each do | t |
  load t
end


task :default => [ :quality, :verify_rcov ]
task :verify_rcov => [ "spec", "cucumber" ]

desc "Enforce Ruby code quality with static analysis of code"
task :quality => [ :reek, :roodi, :flog, :flay ]


def rcov_dat
  File.join File.dirname( __FILE__ ), "coverage.dat"
end


def rcov_opts
  [ "--aggregate #{ rcov_dat }", "--exclude /home/build/.gem", "-T" ]
end


# an alias for Emacs feature-mode.
task :features => [ :cucumber ]
Cucumber::Rake::Task.new do | t |
  rm_f rcov_dat
  t.rcov = true
  t.rcov_opts = rcov_opts
end


desc "Run specs with RCov"
Spec::Rake::SpecTask.new do | t |
  t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
  t.spec_opts = [ "--color", "--format", "nested" ]
  t.rcov = true
  t.rcov_opts = rcov_opts
end


RCov::VerifyTask.new do | t |
  t.threshold = 100.00
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
