class View
  def initialize debug_options
    @stdin = debug_options[ :stdin ]
    @messenger = debug_options[ :messenger ]
  end


  def show node, locks
    info "#{ node }:"
    locks.sort.each do | each |
      info "  #{ each }"
    end
  end


  def show_locks_with_index nodes, locks
    info "#{ nodes.join ', ' }:"
    locks.sort.each_with_index do | each, idx |
      info "  #{ idx }) #{ each }"
    end
  end


  def prompt_select_from locks
    print "Select [0..#{ locks.size - 1 }] (default = 0):"
    case id = stdin.gets.chomp
    when /\A\d+\Z/
      locks[ id.to_i ]
    else
      locks.first
    end
  end


  def prompt_yesno message
    print message
    case stdin.gets.chomp.downcase
    when "y", ""
      true
    else
      nil
    end
  end


  ##############################################################################
  private
  ##############################################################################


  def stdin
    @stdin || $stdin
  end


  def print message
    ( @messenger || $stdout ).print message
  end


  def info message
    ( @messenger || $stdout ).puts message
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
