require "app"
require "locker"


#
# A Node unlocker class.
#
class AppUnlock < App
  def parse argv
    @opt.on( "--yes" ) do
      @yes = true
    end
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
    @opt.parse! argv
    @nodes = argv[ 0 ].split( "," )
  end


  def start
    setup
    if @nodes.size == 1
      maybe_unlock_one_node @nodes.first
    else
      maybe_unlock_multiple_nodes
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def setup
    @view = View.new( @debug_options.merge :quiet => @yes )
    @locker = Locker.new
    @locker.load_locks @data
  end


  def maybe_unlock_one_node node
    locks = @locker.locks( node )
    @view.show_locks_with_index [ node ], locks
    if @yes
      locks.each do | each |
        release_all node, each 
      end
    else
      release_all node, select_from( locks )
    end
  end


  def maybe_unlock_multiple_nodes
    locks = get_common_locks
    @view.show_locks_with_index @nodes, locks
    release select_from( locks )
  end


  def select_from locks
    default_lock = locks.first
    return default_lock if @yes
    return default_lock if locks.size == 1 && @view.prompt_yesno( "Unlock? [Y/n]" )
    id = @view.prompt_select_from( locks )
    locks[ id ]
  end


  def release lock
    @nodes.each do | each |
      @locker.unlock each, lock
    end
  end


  def release_all node, lock
    @locker.unlock node, lock
    unlock_similar_locks lock
  end


  def get_common_locks
    @nodes.inject( @locker.locks( @nodes.first ) ) do | result, each |
      result & @locker.locks( each )
    end
  end


  def unlock_similar_locks lock
    unless @locker.find_nodes_locked_with( lock ).empty?
      if prompt_unlock_similar_locks lock
        @locker.unlock_all lock
      end
    end
  end


  def prompt_unlock_similar_locks lock
    @locker.find_nodes_locked_with( lock ).each do | node |
      @view.show node, [ lock ]
    end
    @view.prompt_yesno( "Unlock similar locks? [Y/n]" )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
