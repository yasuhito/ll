require "ll"
require "lock"


class Locker
  def initialize
    @locks = {}
  end


  def lock nodes, from, to
    new_lock = Lock.new( from, to )
    nodes.each do | each |
      raise LL::LockError, "Failed to lock #{ each }" if already_locked?( each, new_lock )
    end
    nodes.each do | each |
      if @locks[ each ].nil?
        @locks[ each ] = [ new_lock ]
      else
        @locks[ each ] << new_lock
      end
    end
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


  def nodes
    @locks.keys
  end


  def status node
    @locks[ node ].sort
  end


  ##############################################################################
  private
  ##############################################################################


  def already_locked? node, lock
    return unless @locks[ node ]
    @locks[ node ].inject( false ) do | result, each |
      result ||= each.overwrap_with( lock )
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
