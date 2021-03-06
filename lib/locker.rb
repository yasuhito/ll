require "ll"
require "lock"
require "node"
require "resolv"


#
# A Locker class
#
class Locker
  def initialize debug_options = {}
    @debug_options = debug_options
  end


  def load_locks data
    @data = data
    if FileTest.exists?( @data )
      @list = Marshal.load( IO.read( @data ) )
    else
      @list = Hash.new( [] )
    end
    delete_obsolete_locks
  end


  def test nodes, new_lock
    nodes.each do | each |
      test_lock each, new_lock
    end
  end


  def lock nodes, new_lock
    try_lock nodes, new_lock
    nodes.each do | each |
      @list[ each ] += [ new_lock ]
    end
    save
  end


  def unlock node
    @list[ node.name ].delete_if do | each |
      each == node.lock
    end
    save
  end


  def unlock_all lock
    nodes.each do | each |
      unlock Node.new( each, lock )
    end
  end


  def find_nodes_locked_with lock
    nodes.inject( [] ) do | result, each |
      if @list[ each ].include?( lock )
        result + [ each ]
      else
        result
      end
    end
  end


  def nodes
    @list.keys.sort
  end


  def locks
    @list.dup
  end


  def locks_for node
    @list[ node ].dup
  end


  ##############################################################################
  private
  ##############################################################################


  def test_lock node, new_lock
    locks_for( node ).each do | each |
      raise LL::LockError, "Failed to lock #{ node }" if each.conflict_with( new_lock )
    end
  end


  def try_lock nodes, lock
    nodes.each do | each |
      unless valid_nodename?( each )
        raise LL::LockError, "Failed to lock #{ each }: invalid node name"
      end
      unless lockable?( each, lock )
        raise LL::LockError, "Failed to lock #{ each }"
      end
    end
  end


  def valid_nodename? node
    return true if @debug_options[ :no_resolver ]
    Resolv.getaddress( node ) rescue nil
  end


  def lockable? node, lock
    locks_for( node ).inject( true ) do | result, each |
      result && ( not each.overwrap_with( lock ) )
    end
  end


  def delete_obsolete_locks
    nodes.each do | each |
      delete_obsolete_locks_of each
    end
    save
  end


  def delete_obsolete_locks_of node
    @list[ node ].delete_if do | lock |
      lock.obsolete?
    end
  end


  def save
    File.open( @data, "w" ) do | dat |
      dat.print Marshal.dump( @list )
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
