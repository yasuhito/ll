require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe Locker do
  before :each do
    @data = "/tmp/ll.dat"
    FileUtils.rm_f @data
    @locker = Locker.new( @data, :no_resolver => true )
    @time_now = Time.now
    @yutaro_lock = Lock.new( Chronic.parse( "2019-05-27 05:00" ), Chronic.parse( "2019-05-27 08:00" ), "yutaro" )
    @yasuhito_lock = Lock.new( Chronic.parse( "2019-05-27 21:00" ), Chronic.parse( "2019-05-27 22:00" ), "yasuhito" )
  end


  it "should find nodes locked with a specified lock" do
    @locker.lock "node001", @yasuhito_lock
    @locker.lock "node002", @yasuhito_lock
    @locker.lock "node002", @yutaro_lock
    @locker.lock "node003", @yutaro_lock

    @locker.find_nodes_locked_with( @yasuhito_lock ).should == [ "node001", "node002" ]
    @locker.find_nodes_locked_with( @yutaro_lock ).should == [ "node002", "node003" ]
  end


  context "when acquiring a lock" do
    before :each do
      @lock_today = Lock.new( @time_now, Chronic.parse( "this midnight" ), "yasuhito" )
    end


    it "should raise if failed to resolve nodes' IP address" do
      locker = Locker.new( @data )
      lambda do
        locker.lock [ "NO_SUCH_NODE" ], @yutaro_lock
      end.should raise_error( LL::LockError, "Failed to lock NO_SUCH_NODE: invalid node name" )
    end


    it "should lock a node today" do
      @locker.lock [ "node001" ], @lock_today
      @locker.locks( "node001" ).size.should == 1
      @locker.locks( "node001" ).first.from.should == @time_now
      @locker.locks( "node001" ).first.to.should == Chronic.parse( "this midnight" )
    end


    it "should lock a node 8 hours" do
      lock_8h = Lock.new( @time_now, @time_now + 8.hours, "yasuhito" )
      @locker.lock [ "node001" ], lock_8h
      @locker.locks( "node001" ).size.should == 1
      @locker.locks( "node001" ).first.duration.should == 8.hours
    end


    it "should lock a node 3 days from tomorrow" do
      lock_3d = Lock.new( Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow" ) + 3.days, "yasuhito" )
      @locker.lock [ "node001" ], lock_3d
      @locker.locks( "node001" ).size.should == 1
      @locker.locks( "node001" ).first.duration.should == 3.days
    end


    context "and someone already locked node001 today" do
      before :each do
        @locker.lock [ "node001" ], @lock_today
      end


      it "should fail to lock node001 today" do
        lambda do
          @locker.lock [ "node001" ], @lock_today
        end.should raise_error( LL::LockError, "Failed to lock node001" )
      end


      it "should succeed to lock node001 tomorrow" do
        lambda do
          lock_tomorrow = Lock.new( Chronic.parse( "tomorrow" ), Chronic.parse( "tomorrow midnight" ), "yasuhito" )
          @locker.lock [ "node001" ], lock_tomorrow
        end.should_not raise_error
      end
    end
  end


  context "when releasing locks" do
    it "should unlock a node" do
      @locker.lock "node001", @yutaro_lock
      @locker.lock "node001", @yasuhito_lock

      @locker.unlock "node001", @yasuhito_lock
      @locker.locks( "node001" ).should == [ @yutaro_lock ]
      @locker.unlock "node001", @yutaro_lock
      @locker.locks( "node001" ).should be_empty
    end


    it "should delete similar locks from its list" do
      @locker.lock "node001", @yasuhito_lock
      @locker.lock "node002", @yasuhito_lock
      @locker.lock "node002", @yutaro_lock
      @locker.lock "node003", @yutaro_lock

      @locker.unlock_all( @yasuhito_lock )
      @locker.locks( "node001" ).should be_empty
      @locker.locks( "node002" ).should == [ @yutaro_lock ]
      @locker.locks( "node003" ).should == [ @yutaro_lock ]
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
