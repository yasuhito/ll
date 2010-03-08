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
      locks = @locker.locks( node )
      if @yes
        locks.each do | each |
          @locker.unlock node, each
          remove_similar_locks each
        end
      else
        show_locks node, locks unless @yes
        id = select_a_lock( node, locks )
        return unless id
        lock = locks[ id ]
        return unless lock
        @locker.unlock node, lock
        remove_similar_locks lock
      end
    else
      locks = get_common_locks
      if @yes
        @nodes.each do | node |
          locks.each do | lock |
            @locker.unlock node, lock
          end
        end
      end
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def get_common_locks
    @nodes.inject( @locker.locks( @nodes.first ) ) do | result, each |
      result & @locker.locks( each )
    end
  end


  def show_locks node, locks
    return if locks.size == 0
    @view.show_with_index node, locks
  end


  def select_a_lock node, locks
    if @yes
      0
    else
      get_lock_id locks
    end
  end


  def get_lock_id locks
    locks_size = locks.size
    if locks_size == 1
      0 if @view.prompt_yesno( "Unlock? [Y/n]" )
    else
      @view.prompt_select "Select [0..#{ locks_size - 1 }]"
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
