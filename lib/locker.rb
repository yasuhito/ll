require "ll"
require "lock"
require "resolv"


#
# A Locker class
#
class Locker
  def initialize data, debug_options = {}
    @data = data
    @debug_options = debug_options
    if FileTest.exists?( @data )
      @list = Marshal.load( IO.read( @data ) )
    else
      @list = Hash.new( [] )
    end
    delete_obsolete_locks
  end


  def lock nodes, new_lock
    try_lock nodes, new_lock
    add nodes, new_lock
  end


  def unlock node, lock
    @list[ node ].delete_if do | each |
      each == lock
    end
    save
  end


  def unlock_all lock
    nodes.each do | each |
      unlock each, lock
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


  def locks node
    @list[ node ].sort!
  end


  ##############################################################################
  private
  ##############################################################################


  def add nodes, lock
    nodes.each do | each |
      @list[ each ] += [ lock ]
    end
    save
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
    @list[ node ].inject( true ) do | result, each |
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
