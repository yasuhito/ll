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
      info "  #{ @locker.status( @node )[ 0 ] }"
      show_yesno_prompt
    else
      @locker.status( @node ).each_with_index do | each, idx |
        info "  #{ idx }) #{ each }"
      end
      show_select_prompt
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def show_yesno_prompt
    print "Unlock? [Y/n]"
    yesno = $stdin.gets.chomp.downcase
    if yesno == "" || yesno == "y"
      remove_similar_locks_with @locker.status( @node )[ 0 ]
      @locker.status( @node ).delete_at 0
      save
    end
  end


  def show_select_prompt
    info "Select (0..#{ @locker.status( @node ).size - 1 })"
    id = $stdin.gets.chomp
    return if id == ""
    id = id.to_i
    remove_similar_locks_with @locker.status( @node )[ id ]
    @locker.status( @node ).delete_at id
    save
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
    if @locker.find_similar_locks( lock ) != [[ @node, lock ]]
      show_similar_locks lock
      print "Unlock similar locks? [Y/n]"
      yesno = $stdin.gets.chomp.downcase
      return unless yesno == "" || yesno == "y"
      ( @locker.nodes - [ @node ] ).each do | each |
        @locker.status( each ).each_with_index do | l, i |
          if l.duration == lock.duration
            @locker.status( each ).delete_at i
          end
        end
      end
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
