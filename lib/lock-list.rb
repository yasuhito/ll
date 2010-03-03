class LockList < Hash
  def add node, lock
    if self[ node ].nil?
      self[ node ] = [ lock ]
    else
      self[ node ] << lock
    end
  end


  def lockable? node, lock
    return true if self[ node ].nil?
    self[ node ].inject( true ) do | result, each |
      result &= ( not each.overwrap_with( lock ) )
    end
  end


  def find_similar_locks lock
    result = []
    self.keys.each do | each |
      self[ each ].each do | l |
        if l.duration == lock.duration
          result << [ each, l ]
        end
      end
    end
    result
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
