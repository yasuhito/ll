require "app"


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
    locks = @locker.status( @node )
    return if locks.size == 0
    @view.show_with_index @node, locks
    lock = select_lock
    remove_similar_locks lock if lock
  end


  ##############################################################################
  private
  ##############################################################################


  def show_similar_locks lock
    @locker.find_similar_locks( lock ).each do | node |
      @view.show node, [ lock ] if node != @node
    end
  end


  def remove_similar_locks lock
    @locker.delete @node, lock
    unless @locker.find_similar_locks( lock ).empty?
      show_similar_locks lock
      return unless prompt_yesno( "Unlock similar locks? [Y/n]" )
      @locker.delete_similar_locks( lock )
    end
  end


  def select_lock
    if @locker.status( @node ).size == 1
      prompt_yesno "Unlock? [Y/n]"
    else
      prompt_select
    end
  end


  def prompt_select
    locks = @locker.status( @node )
    print "Select [0..#{ locks.size - 1 }]"
    id = $stdin.gets.chomp
    return if id == ""
    locks[ id.to_i ]
  end


  def prompt_yesno message
    print message
    yesno = $stdin.gets.chomp.downcase
    if yesno == "" || yesno == "y"
      @locker.status( @node )[ 0 ]
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
