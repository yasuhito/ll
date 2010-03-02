require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Locker do
  before :each do
    @locker = Locker.new
    @time_now = Time.now
  end


  context "when attempt to acquire a lock for a node" do
    it "should lock a node today" do
      @locker.lock [ "tick001" ], @time_now, Chronic.parse( "this midnight" )
      @locker.status( "tick001" ).size.should == 1
      @locker.status( "tick001" ).first.duration.should < 86400 # 1 day
    end


    it "should lock a node 8 hours" do
      @locker.lock [ "tick001" ], @time_now, @time_now + ChronicDuration.parse( "8 hours" )
      @locker.status( "tick001" ).size.should == 1
      @locker.status( "tick001" ).first.duration.should == 28800 # 8 hours
    end


    it "should lock a node 3 days from tomorrow" do
      @locker.lock [ "tick001" ], Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow" ) + ChronicDuration.parse( "3 days" )
      @locker.status( "tick001" ).size.should == 1
      @locker.status( "tick001" ).first.duration.should == 259200 # 3 days
    end
  end


  context "when someone alredy locked tick001 today" do
    before :each do
      @locker.lock [ "tick001" ], @time_now, Chronic.parse( "this midnight" )
    end


    it "should fail to lock tick001" do
      lambda do
        @locker.lock [ "tick001" ], @time_now, Chronic.parse( "this midnight" )
      end.should raise_error( LL::LockError, "Failed to lock tick001" )
    end


    it "should succeed to lock tick001 tomorrow" do
      lambda do
        @locker.lock [ "tick001" ], Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow" ) + ChronicDuration.parse( "24 hours" )
      end.should_not raise_error
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
