require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe AppUnlock do
  before :each do
    @data = "/tmp/ll.dat"
    FileUtils.rm_f @data
    app = AppLock.new( :no_resolver => true )
    app.parse [ "--data", @data, "node001,node002,node003" ]
    app.start
  end


  it "should unlock nodes" do
    messenger = StringIO.new
    app = AppUnlock.new( messenger )
    app.parse [ "--yes", "--data", @data, "node001,node002,node003" ]
    app.start
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
