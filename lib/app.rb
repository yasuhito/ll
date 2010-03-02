require "locker"
require "optparse"


#
# A base class for ll commands.
#
class App
  DEFAULT_DATA = File.join( File.dirname( __FILE__ ), "..", "ll.dat" )


  def initialize messenger = nil
    @locker = Locker.new
    @opt = OptionParser.new
    @messenger = messenger
  end


  def load
    @locker.load data
  end


  def save
    @locker.save data
  end


  ##############################################################################
  private
  ##############################################################################


  def info message
    ( @messenger || $stdout ).puts message
  end


  def data
    @data || DEFAULT_DATA
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
