require "app"
require "locker"


#
# Displays lock status.
#
class AppShow < App
  def parse argv = []
    @opt.on( "--json" ) do
      @json = true
    end
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
    @opt.parse! argv
    @argv = argv
  end


  def start
    @view = View.new( @json ? :json : :text, @debug_options )
    @locker = Locker.new( @data )
    @locker.load_locks @data
    @view.show nodes, @locker.locks
  end


  ##############################################################################
  private
  ##############################################################################


  def nodes
    @argv.empty? ? @locker.nodes : @argv[ 0 ].split( "," )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
