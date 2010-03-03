#
# A lock list manager class.
#
class LockList
  def initialize data
    @data = data
    if FileTest.exists?( @data )
      @list = Marshal.load( IO.read( @data ) )
    else
      @list = Hash.new( [] )
    end
    delete_obsolete_locks
  end


  def add nodes, lock
    nodes.each do | each |
      @list[ each ] += [ lock ]
    end
    save
  end


  def delete node, lock
    @list[ node ] -= [ lock ]
    save
  end


  def find_similar_locks lock
    nodes.inject( [] ) do | result, each |
      result << each if @list[ each ].include?( lock )
      result
    end
  end


  def delete_similar_locks lock
    nodes.each do | each |
      delete each, lock
    end
  end


  def try_lock nodes, lock
    nodes.each do | each |
      unless lockable?( each, lock )
        raise LL::LockError, "Failed to lock #{ each }"
      end
    end
  end


  def nodes
    @list.keys.sort
  end


  def status node
    @list[ node ].sort!
  end


  ##############################################################################
  private
  ##############################################################################


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
