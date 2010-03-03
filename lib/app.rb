require "locker"
require "optparse"
require "view"


#
# A base class for ll commands.
#
class App
  DEFAULT_DATA = File.join( File.dirname( __FILE__ ), "..", "ll.dat" )


  def initialize messenger = nil
    @data = DEFAULT_DATA
    @view = View.new( messenger )
    @opt = OptionParser.new
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
