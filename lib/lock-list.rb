class LockList < Hash
  def initialize
    @list = {}
  end


  def add node, lock
    if @list[ node ].nil?
      @list[ node ] = [ lock ]
    else
      @list[ node ] << lock
    end
  end


  def delete node, lock
    @list[ node ] -= [ lock ]
    @list.delete node if @list[ node ].empty?
  end


  def lockable? node, lock
    return true if @list[ node ].nil?
    @list[ node ].inject( true ) do | result, each |
      result &= ( not each.overwrap_with( lock ) )
    end
  end


  def find_similar_locks lock
    result = []
    nodes.each do | each |
      @list[ each ].each do | l |
        result << [ each, l ] if l == lock
      end
    end
    result
  end


  def delete_similar_locks lock
    nodes.each do | each |
      @list[ each ].delete_if do | l |
        l == lock
      end
      @list.delete each if @list[ each ].empty?
    end
  end


  def nodes
    @list.keys.sort
  end


  def status node
    @list[ node ].sort! if @list[ node ]
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
