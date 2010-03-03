require "locker"
require "optparse"


#
# A base class for ll commands.
#
class App
  DEFAULT_DATA = File.join( File.dirname( __FILE__ ), "..", "ll.dat" )


  def initialize messenger = nil
    @data = DEFAULT_DATA
    @opt = OptionParser.new
    @messenger = messenger
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
