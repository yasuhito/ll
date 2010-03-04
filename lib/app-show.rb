require "app"
require "lock-list"


#
# Displays lock status.
#
class AppShow < App
  def parse argv
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
    @opt.parse! argv
    @locker = LockList.new( @data )
    @argv = argv
  end


  def start
    nodes.each do | node |
      show node
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def show node
    status = @locker.locks( node )
    return if status.empty?
    @view.show node, status
  end


  def nodes
    @argv.empty? ? @locker.nodes : @argv[ 0 ].split( "," )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
