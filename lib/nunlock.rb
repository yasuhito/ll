require "app"


#
# A Node unlocker class.
#
class Nunlock < App
  def parse argv
    @node = argv[ 0 ]
  end


  def start
    load
    info "#{ @node }:"
    if @locker.status( @node ).size == 1
      lock = @locker.status( @node )[ 0 ]
      info "  #{ lock }"
      if prompt( "Unlock? [Y/n]" )
        @locker.delete @node, lock
        remove_similar_locks_with lock
        save
      end
    else
      @locker.status( @node ).each_with_index do | each, idx |
        info "  #{ idx }) #{ each }"
      end
      id = prompt_select
      if id
        lock = @locker.status( @node )[ id ]
        @locker.delete @node, lock
        remove_similar_locks_with lock
        save
      end
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def prompt_select
    info "Select (0..#{ @locker.status( @node ).size - 1 })"
    id = $stdin.gets.chomp
    return if id == ""
    id.to_i
  end


  def show_similar_locks lock
    @locker.find_similar_locks( lock ).each do | node, lock |
      if node != @node
        info "#{ node }:"
        info "  #{ lock }"
      end
    end
  end


  def remove_similar_locks_with lock
    unless @locker.find_similar_locks( lock ).empty?
      show_similar_locks lock
      return unless prompt( "Unlock similar locks? [Y/n]" )
      @locker.delete_similar_locks( lock )
    end
  end


  def prompt message
    print message
    yesno = $stdin.gets.chomp.downcase
    yesno == "" || yesno == "y"
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
