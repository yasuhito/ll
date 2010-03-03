class View
  def initialize messenger
    @messenger = messenger
  end


  def show node, locks
    info "#{ node }:"
    locks.each do | each |
      info "  #{ each }"
    end
  end


  def show_with_index node, locks
    info "#{ node }:"
    locks.each_with_index do | each, idx |
      info "  #{ idx }) #{ each }"
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def info message
    ( @messenger || $stdout ).puts message
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
