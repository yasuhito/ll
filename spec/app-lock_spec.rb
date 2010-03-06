require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe AppLock do
  context "when locking a node" do
    before :each do
      @data = "/tmp/ll.dat"
      FileUtils.rm_f @data
      @app = AppLock.new( :no_resolver => true )
    end


    it "should lock for 1 hour as default" do
      @app.parse [ "--data", @data, "node001" ]
      @app.start
      @app.locks_for( "node001" ).first.duration.should == 1.hour
    end


    it "should lock today" do
      @app.parse [ "--data", @data, "node001", "today" ]
      @app.start
      @app.locks_for( "node001" ).first.to.should == Chronic.parse( "this midnight" )
    end


    it "should lock with --from option" do
      @app.parse [ "--data", @data, "node001", "2hours", "--from", "tomorrow" ]
      @app.start
      @app.locks_for( "node001" ).first.duration.should == 2.hours
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
