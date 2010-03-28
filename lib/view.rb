#
# CUI views for ll command
#
class View
  def initialize debug_options
    @quiet = debug_options[ :quiet ]
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
    read_from_stdin.to_i
  end


  def prompt_yesno message
    return true if @quiet
    print message
    input = read_from_stdin.downcase
    input == "y" || input == ""
  end


  ##############################################################################
  private
  ##############################################################################


  def read_from_stdin
    ( @stdin || $stdin ).gets.chomp
  end


  def print message
    ( @messenger || $stdout ).print message
  end


  def info message
    return if @quiet
    ( @messenger || $stdout ).puts message
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
