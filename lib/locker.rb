require "ll"
require "lock"
require "lock-list"


#
# A lock manager class
#
class Locker
  def initialize data
    @locks = LockList.new( data )
  end


  def lock nodes, from, to
    new_lock = Lock.new( from, to )
    @locks.try_lock nodes, new_lock
    @locks.add nodes, new_lock
  end


  def method_missing message, *args
    @locks.__send__ message, *args
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
