require "rake/tasklib"
require "cucumber/rake/task"
require "flay"
require "flay_task"
require "flog"
require "rake/clean"
require "reek/adapters/rake_task"
require "roodi"
require "roodi_task"
require "spec/rake/spectask"
require "spec/rake/verify_rcov"
require "hanna/rdoctask"


task :default => [ :quality, :verify_rcov ]


desc "Enforce Ruby code quality with static analysis of code"
task :quality => [ :reek, :roodi, :flog, :flay ]


Reek::RakeTask.new do | t |
  t.fail_on_error = true
  t.verbose = false
  t.reek_opts = "--quiet"
  t.source_files = "lib/**/*.rb"
end


RoodiTask.new do | t |
  t.patterns =  [ "lib/**/*.rb" ]
end


desc "Analyze for code complexity"
task :flog do
  flog = Flog.new
  flog.flog [ "lib" ]
  threshold = 10

  bad_methods = flog.totals.select do | name, score |
    name != "main#none" && score > threshold
  end
  bad_methods.sort do | a, b |
    a[ 1 ] <=> b[ 1 ]
  end.each do | name, score |
    puts "%8.1f: %s" % [ score, name ]
  end
  unless bad_methods.empty?
    raise "#{ bad_methods.size } methods have a flog complexity > #{ threshold }"
  end
end


FlayTask.new do | t |
  t.dirs = [ "lib", "script" ]
  t.threshold = 0
end


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


task :verify_rcov => [ "spec", "cucumber" ]
RCov::VerifyTask.new do | t |
  t.threshold = 100.00
end


# Rdoc Task ####################################################################

Rake::RDocTask.new do | t |
  t.main = "README"
  t.rdoc_files.include "README", "lib/**/*.rb"
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
