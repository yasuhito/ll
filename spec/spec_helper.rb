$LOAD_PATH << File.join( File.dirname( __FILE__ ), "/../lib" )


require "rubygems"

require "active_support"
require "app-lock"
require "app-show"
require "app-unlock"
require "chronic"
require "chronic_duration"
require "lock"
require "locker"
require "spec"
require "view"


def new_lock duration
  Lock.new( Chronic.parse( duration[ :from ] ), Chronic.parse( duration[ :to ] ), "yutaro" )
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
