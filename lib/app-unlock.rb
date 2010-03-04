require "app"
require "lock-list"


#
# A Node unlocker class.
#
class AppUnlock < App
  def parse argv
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
    @opt.parse! argv
    @locker = Locker.new( @data )
    @node = argv[ 0 ]
  end


  def start
    locks = @locker.locks( @node )
    return if locks.size == 0
    @view.show_with_index @node, locks
    lock = select_a_lock
    remove_similar_locks lock if lock
  end


  ##############################################################################
  private
  ##############################################################################


  def show_similar_locks lock
    @locker.find_nodes_locked_with( lock ).each do | node |
      @view.show node, [ lock ] if node != @node
    end
  end


  def remove_similar_locks lock
    @locker.unlock @node, lock
    unless @locker.find_nodes_locked_with( lock ).empty?
      show_similar_locks lock
      return unless prompt_yesno( "Unlock similar locks? [Y/n]" )
      @locker.unlock_all lock
    end
  end


  def select_a_lock
    id = get_lock_id
    @locker.locks( @node )[ id ] if id
  end


  def get_lock_id
    locks_size = @locker.locks( @node ).size
    if locks_size == 1
      0 if prompt_yesno( "Unlock? [Y/n]" )
    else
      prompt_select "Select [0..#{ locks_size - 1 }]"
    end
  end


  def prompt_select message
    print message
    case id = $stdin.gets.chomp
    when /\A\d+\Z/
      id.to_i
    else
      nil
    end
  end


  def prompt_yesno message
    print message
    case $stdin.gets.chomp.downcase
    when "y", ""
      true
    else
      nil
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
