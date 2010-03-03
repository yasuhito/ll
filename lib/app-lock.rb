require "rubygems"

require "app"
require "chronic_duration"


#
# Node locker class
#
class AppLock < App
  DEFAULT_DURATION = ChronicDuration.parse( "1 hour" )


  def initialize messenger = nil
    super messenger
    @from = Time.now
    setup_option_parser
  end


  def parse argv
    @opt.parse!( argv )
    @locker = Locker.new( @data )
    @nodes = argv.shift.split( "," )
    @to = determine_duration_end( argv[ 0 ] )
  end


  # [FIXME] global lock
  def start
    @locker.lock @nodes, @from, @to
  end


  def locks_for node
    @locker.status node
  end


  ##############################################################################
  private
  ##############################################################################


  def determine_duration_end natural_time
    if natural_time.nil?
      @from + DEFAULT_DURATION
    else
      if natural_time == "today"
        Chronic.parse "this midnight"
      else
        duration = ChronicDuration.parse( natural_time )
        if duration.nil?
          raise "Parse error '#{ natural_time }'"
        else
          @from + ChronicDuration.parse( natural_time )
        end
      end
    end
  end


  def setup_option_parser
    @opt.on( "--from [TIME]" ) do | val |
      require "chronic"
      @from = Chronic.parse( val )
    end
    @opt.on( "--data [FILE]" ) do | val |
      @data = val
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
