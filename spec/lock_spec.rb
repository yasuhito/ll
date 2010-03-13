require File.join( File.dirname( __FILE__ ), "spec_helper" )


Spec::Matchers.define :overwrap_with do | other |
  match do | lock |
    lock.overwrap_with other
  end
end


describe Lock do
  before :each do
    @one_hour = ChronicDuration.parse( "1 hour" )
    @user = "yutaro"
  end


  it "should be sorted with <=>" do
    lock_old = Lock.new( Chronic.parse( "1979-05-27 04:00" ), Chronic.parse( "1979-05-27 05:00" ), @user )
    lock_new = Lock.new( Chronic.parse( "1979-05-27 05:00" ), Chronic.parse( "1979-05-27 06:00" ), @user )
    ( lock_old <=> lock_new ).should == -1
    ( lock_old <=> lock_old ).should == 0
    ( lock_new <=> lock_new ).should == 0
    ( lock_new <=> lock_old ).should == 1
  end


  context "when detecting overwrap" do
    subject { Lock.new( Chronic.parse( "1979-05-27 04:00" ), Chronic.parse( "1979-05-27 06:00" ), @user ) }
    other = Lock.new( Chronic.parse( "1979-05-27 05:00" ), Chronic.parse( "1979-05-27 07:00" ), @user )
    it { should overwrap_with( other ) }
  end


  context "when calculating its duration" do
    from = Chronic.parse( "1979-05-27 05:00" )
    subject { Lock.new( from, from + @one_hour, @user ) }
    its( :duration ) { should == @one_hour }
  end


  context "when compared with an another lock" do
    before :each do
      @from = Chronic.parse( "1979-05-27 05:00" )
      @to = Chronic.parse( "1979-05-27 06:00" )
    end


    context "when their durations are same" do
      subject { Lock.new( @from, @to, @user ) }
      it { should == Lock.new( @from, @to, @user ) }
    end


    context "when their durations are not same" do
      subject { Lock.new( @from, @to, @user ) }
      it { should_not == Lock.new( @from, @to + @one_hour, @user ) }
    end
  end


  context "when testing its liveness" do
    context "when it is expired" do
      past = Chronic.parse( "1979-05-27 05:00" )
      subject { Lock.new( past - @one_hour, past, @user ) }
      it { should be_obsolete }
    end


    context "when it is alive" do
      now = Time.now
      subject { Lock.new( now, now + @one_hour, @user ) }
      it { should_not be_obsolete }
    end
  end


  context "when converted to a string" do
    context "when its duration falls within a day" do
      it "should be shortened like: [user] yyyy/mm/dd (Sun) hh:mm - hh:mm" do
        lock = Lock.new( Chronic.parse( "1979-05-27 05:00" ), Chronic.parse( "1979-05-27 06:00" ), @user )
        lock.to_s.should == "[yutaro] 1979/05/27 (Sun) 05:00 - 06:00"
      end
    end


    context "when its duration crosses 00:00" do
      it "should be shortened like: [user] yyyy/mm/dd (Wed) hh:mm - mm/dd (Thu) hh:mm" do
        lock = Lock.new( Chronic.parse( "1979-05-27 23:00" ), Chronic.parse( "1979-05-28 01:00" ), @user )
        lock.to_s.should == "[yutaro] 1979/05/27 (Sun) 23:00 - 05/28 (Mon) 01:00"
      end
    end


    context "when its duration crosses the last day of a month" do
      it "should be shortened like: [user] yyyy/mm/dd (Wed) hh:mm - mm/dd (Thu) hh:mm" do
        lock = Lock.new( Chronic.parse( "1979-01-31 23:00" ), Chronic.parse( "1979-02-1 01:00" ), @user )
        lock.to_s.should == "[yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00"
      end
    end


    context "when its duration crosses a new year's day" do
      it "should not be shortened, converted like: [user] yyyy/mm/dd (Wed) hh:mm - yyyy/mm/dd (Thu) hh:mm" do
        lock = Lock.new( Chronic.parse( "1978-12-31 23:00" ), Chronic.parse( "1979-01-01 01:00" ), @user )
        lock.to_s.should == "[yutaro] 1978/12/31 (Sun) 23:00 - 1979/01/01 (Mon) 01:00"
      end
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
