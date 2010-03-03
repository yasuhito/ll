#
# A lock list manager class.
#
class LockList < Hash
  def initialize
    @list = Hash.new( [] )
  end


  def add node, lock
    @list[ node ] += [ lock ]
  end


  def delete node, lock
    @list[ node ] -= [ lock ]
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


  def lockable? node, lock
    @list[ node ].inject( true ) do | result, each |
      result && ( not each.overwrap_with( lock ) )
    end
  end


  def nodes
    @list.keys.sort
  end


  def status node
    @list[ node ].sort!
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
