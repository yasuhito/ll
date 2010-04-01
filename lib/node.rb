#
# Locked node
#
class Node
  attr_reader :name, :lock


  def initialize name, lock
    @name = name
    @lock = lock
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
