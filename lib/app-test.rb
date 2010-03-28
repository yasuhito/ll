require "app-lock"


#
# Checks if the specified nodes are lockable or not.
#
class AppTest < AppLock
  # [FIXME] global lock
  def start
    @locker.test @nodes, Lock.new( @from, @to, `whoami`.chomp )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:

