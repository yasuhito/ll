require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe AppUnlock do
  before :each do
    @data = "/tmp/ll.dat"
    FileUtils.rm_f @data
    app = AppLock.new( :no_resolver => true )
    app.parse [ "--data", @data, "node001,node002,node003" ]
    app.start
    app.parse [ "--data", @data, "node001,node002,node003", "1hour", "--from", "tomorrow" ]
    app.start
  end


  it "should unlock a node" do
    messenger = StringIO.new
    app_unlock = AppUnlock.new( messenger )
    app_unlock.parse [ "--yes", "--data", @data, "node001" ]
    app_unlock.start
    messenger.string.should be_empty

    messenger = StringIO.new
    app_show = AppShow.new( messenger )
    app_show.parse [ "--data", @data ]
    app_show.start
    messenger.string.should be_empty
  end


  it "should unlock nodes" do
    messenger = StringIO.new
    app = AppUnlock.new( messenger )
    app.parse [ "--yes", "--data", @data, "node001,node002" ]
    app.start
    messenger.string.should be_empty

    messenger = StringIO.new
    app_show = AppShow.new( messenger )
    app_show.parse [ "--data", @data ]
    app_show.start
    messenger.string.should match( /^node003:/ )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
