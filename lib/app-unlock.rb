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
    @locker = Locker.new( @data )
    if @nodes.size == 1
      maybe_unlock_one_node
    else
      maybe_unlock_multiple_nodes
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def maybe_unlock_one_node
    node = @nodes.first
    locks = @locker.locks( node )
    if @yes
      locks.each do | each |
        @locker.unlock node, each
        remove_similar_locks each
      end
    else
      show_locks node, locks
      lock = select_a_lock_to_release( locks )
      return unless lock
      @locker.unlock node, lock
      remove_similar_locks lock
    end
  end


  def maybe_unlock_multiple_nodes
    locks = get_common_locks
    unless @yes
      @view.show_with_index @nodes, locks
    end

    if locks.size == 1
      lock = locks.first
      if @yes || @view.prompt_yesno( "Unlock? [Y/n]" )
        release lock
      end
    else
      lock = unless @yes
               @view.prompt_select_from( locks )
             else
               locks.first
             end
      release lock
    end
  end


  def release lock
    @nodes.each do | each |
      @locker.unlock each, lock
    end
  end


  def get_common_locks
    @nodes.inject( @locker.locks( @nodes.first ) ) do | result, each |
      result & @locker.locks( each )
    end
  end


  def show_locks node, locks
    return if locks.size == 0
    @view.show_with_index [ node ], locks
  end


  def select_a_lock_to_release locks
    if @yes
      locks.first
    else
      select_from locks
    end
  end


  def select_from locks
    locks_size = locks.size
    if locks_size == 1
      locks.first if @view.prompt_yesno( "Unlock? [Y/n]" )
    else
      @view.prompt_select_from locks
    end
  end


  def remove_similar_locks lock
    unless @locker.find_nodes_locked_with( lock ).empty?
      show_similar_locks lock
      if @yes || @view.prompt_yesno( "Unlock similar locks? [Y/n]" )
        @locker.unlock_all lock
      end
    end
  end


  def show_similar_locks lock
    return if @yes
    @locker.find_nodes_locked_with( lock ).each do | node |
      @view.show node, [ lock ]
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
