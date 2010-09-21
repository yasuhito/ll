#
# CUI views for ll command
#
class View
  def initialize mode, debug_options
    @mode = mode
    @quiet = debug_options[ :quiet ]
    @stdin = debug_options[ :stdin ]
    @messenger = debug_options[ :messenger ]
  end


  def show nodes, locks
    if @mode == :json
      require "json"
      show_json locks
    else
      nodes.each do | each |
        show_text each, locks
      end
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


  def show_json locks
    info locks.to_json
  end


  def show_text node, locks
    status = locks[ node ]
    return if status.empty?
    info "#{ node }:"
    status.sort.each do | each |
      info "  #{ each }"
    end
  end


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
