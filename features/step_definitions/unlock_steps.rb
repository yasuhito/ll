# -*- coding: utf-8 -*-
When /^ll unlock "([^\"]*)" でアンロックした$/ do | argv |
  @messenger = StringIO.new
  if /yes/=~ argv
    @app = AppUnlock.new( :messenger => @messenger )
  else
    @app = AppUnlock.new( :messenger => @messenger, :stdin => StringIO.new( "\n" ) )
  end
  @app.parse argv.split( " " ) + [ "--data", @data ]
  @app.start
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
