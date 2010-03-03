module LL
  # Locking error
  class LockError < StandardError; end
  # Natural time parsing error
  class ParseError < StandardError; end


  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    MAINTENANCE = 0

    STRING = [ MAJOR, MINOR, MAINTENANCE ].join( '.' )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
