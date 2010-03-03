require "ll"
require "lock"
require "lock-list"


#
# A lock manager class
#
class Locker
  def initialize
    @locks = LockList.new
  end


  def lock nodes, from, to
    new_lock = Lock.new( from, to )
    check_if_lockable nodes, new_lock
    add_lock nodes, new_lock
  end


  def load file
    if FileTest.exists?( file )
      @locks = Marshal.load( IO.read( file ) )
    end
  end


  def save file
    File.open( file, "w" ) do | f |
      @locks.each_pair do | key, value |
        @locks.delete( key ) if value.empty?
      end
      f.print Marshal.dump( @locks )
    end
  end


  def find_similar_locks lock
    @locks.find_similar_locks lock
  end


  def delete node, lock
    @locks.delete node, lock
  end


  def delete_similar_locks lock
    @locks.delete_similar_locks lock
  end


  def nodes
    @locks.nodes
  end


  def status node
    @locks.status node
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
