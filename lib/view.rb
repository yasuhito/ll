class View
  def initialize messenger
    @messenger = messenger
  end


  def show node, locks
    info "#{ node }:"
    locks.sort.each do | each |
      info "  #{ each }"
    end
  end


  def show_with_index node, locks
    info "#{ node }:"
    locks.sort.each_with_index do | each, idx |
      info "  #{ idx }) #{ each }"
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


  ##############################################################################
  private
  ##############################################################################


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
