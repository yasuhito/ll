require "rubygems"

require "app"
require "chronic_duration"
require "ll"
require "locker"


#
# Node locker class
#
class AppLock < App
  DEFAULT_DURATION = ChronicDuration.parse( "1 hour" )


  def initialize debug_options = {}
    super debug_options
    @locker = Locker.new( debug_options )
    @from = Time.now
    setup_option_parser
  end


  def parse argv
    @opt.parse!( argv )
    @nodes = argv.shift.split( "," )
    @to = determine_duration_end( argv[ 0 ] )
  end


  # [FIXME] global lock
  def start
    @locker.load_locks @data
    @locker.lock @nodes, Lock.new( @from, @to, @debug_options[ :user ] || `whoami`.chomp )
  end


  def locks_for node
    @locker.locks node
  end


  ##############################################################################
  private
  ##############################################################################


  def determine_duration_end natural_time
    case natural_time
    when nil
      @from + DEFAULT_DURATION
    when "today"
      Chronic.parse "this midnight"
    else
      @from + parse_duration( natural_time )
    end
  end


  def parse_duration natural_time
    duration = ChronicDuration.parse( natural_time )
    raise LL::ParseError, "Parse error '#{ natural_time }'" if duration.nil?
    duration
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
