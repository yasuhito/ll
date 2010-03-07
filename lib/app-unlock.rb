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
      node = @nodes.first
      show_locks node
      unlock node
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def show_locks node
    @locks = @locker.locks( node )
    return if @locks.size == 0
    @view.show_with_index node, @locks
  end


  def unlock node
    lock = select_a_lock( node )
    return unless lock
    @locker.unlock node, lock
    remove_similar_locks lock
  end


  def show_similar_locks lock
    @locker.find_nodes_locked_with( lock ).each do | node |
      @view.show node, [ lock ] if node != @nodes[ 0 ]
    end
  end


  def remove_similar_locks lock
    unless @locker.find_nodes_locked_with( lock ).empty?
      show_similar_locks lock
      return unless @yes || @view.prompt_yesno( "Unlock similar locks? [Y/n]" )
      @locker.unlock_all lock
    end
  end


  def select_a_lock node
    id = @yes ? 0 : get_lock_id
    @locks[ id ] if id
  end


  def get_lock_id
    locks_size = @locks.size
    if locks_size == 1
      0 if @view.prompt_yesno( "Unlock? [Y/n]" )
    else
      @view.prompt_select "Select [0..#{ locks_size - 1 }]"
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
