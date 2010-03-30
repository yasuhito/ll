require "rake/clean"


$rcov_dat = File.join File.dirname( __FILE__ ), "coverage.dat"
$rcov_opts = [ "--aggregate #{ $rcov_dat }", "--exclude /home/build/.gem", "-T" ]


Dir[ "tasks/**/*.rake" ].each do | t |
  load t
end


task :default => [ :quality, :verify_rcov ]

desc "Enforce Ruby code quality with static analysis of code"
task :quality => [ :reek, :roodi, :flog, :flay ]

task :verify_rcov => [ :spec, :cucumber ]

# an alias for Emacs feature-mode.
task :features => [ :cucumber ]


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
