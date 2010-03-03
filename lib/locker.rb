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
    check_if_lockable nodes, new_lock
    add_lock nodes, new_lock
  end


  def method_missing message, *args
    @locks.__send__ message, *args
  end


  ##############################################################################
  private
  ##############################################################################


  def add_lock nodes, lock
    nodes.each do | each |
      @locks.add each, lock
    end
  end


  def check_if_lockable nodes, lock
    nodes.each do | each |
      unless @locks.lockable?( each, lock )
        raise LL::LockError, "Failed to lock #{ each }"
      end
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
