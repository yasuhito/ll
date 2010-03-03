require "app"


#
# Displays lock status.
#
class Nshow < App
  def parse argv
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
    @opt.parse! argv
    @argv = argv
  end


  def start
    load
    nodes.each do | node |
      show node
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def show node
    status = @locker.status( node )
    return if status.nil?
    info "#{ node }:"
    status.each do | each |
      info "  #{ each }"
    end
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
