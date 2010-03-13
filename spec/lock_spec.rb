require File.join( File.dirname( __FILE__ ), "spec_helper" )


Spec::Matchers.define :overwrap_with do | duration |
  match do | lock |
    other = Lock.new( Chronic.parse( duration[ :from ] ), Chronic.parse( duration[ :to ] ), "yutaro" )
    lock.overwrap_with other
  end
end


Spec::Matchers.define :be_shortened_into do | string |
  match do | lock |
    lock.to_s == string
  end
end


describe Lock, "with 1 hour of duration from now" do
  context "when testing its liveness" do
    now = Time.now
    subject { Lock.new( now, now + ChronicDuration.parse( "1 hour" ), "yutaro" ) }
    it { should_not be_obsolete }
  end
end


describe Lock, "1979-05-27 (Sun) 04:00 - 06:00" do
  before :each do
    @user = "yutaro"
    @lock = Lock.new( Chronic.parse( "1979-05-27 04:00" ), Chronic.parse( "1979-05-27 06:00" ), @user )
  end


  context "when testing its liveness" do
    subject { @lock }
    it { should be_obsolete }
  end


  context "when detecting overwrap" do
    subject { @lock }
    it { should overwrap_with( :from => "1979-05-27 05:00", :to => "1979-05-27 07:00" ) }
    it { should overwrap_with( :from => "1979-05-27 03:00", :to => "1979-05-27 05:00" ) }
    it { should overwrap_with( :from => "1979-05-27 03:00", :to => "1979-05-27 07:00" ) }
    it { should overwrap_with( :from => "1979-05-27 05:00", :to => "1979-05-27 05:30" ) }
    it { should_not overwrap_with( :from => "1979-05-27 07:00", :to => "1979-05-27 08:00" ) }
  end


  context "when calculating its duration" do
    subject { @lock }
    its( :duration ) { should == ChronicDuration.parse( "2 hours" ) }
  end


  context "when compared with an another lock" do
    subject { @lock }
    it { should == Lock.new( Chronic.parse( "1979-05-27 04:00" ), Chronic.parse( "1979-05-27 06:00" ), @user ) }
    it { should_not == Lock.new( Chronic.parse( "1979-05-27 05:00" ), Chronic.parse( "1979-05-27 06:00" ), @user ) }
  end
end


describe Lock do
  before :each do
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
end


describe Lock, "when represented as a string" do
  before :each do
    @user = "yutaro"
  end


  context "when its duration falls within a day" do
    subject { Lock.new( Chronic.parse( "1979-05-27 05:00" ), Chronic.parse( "1979-05-27 06:00" ), @user ) }
    it { should be_shortened_into( "[yutaro] 1979/05/27 (Sun) 05:00 - 06:00" ) }
  end


  context "when its duration crosses 00:00" do
    subject { Lock.new( Chronic.parse( "1979-05-27 23:00" ), Chronic.parse( "1979-05-28 01:00" ), @user ) }
    it { should be_shortened_into( "[yutaro] 1979/05/27 (Sun) 23:00 - 05/28 (Mon) 01:00" ) }
  end


  context "when its duration crosses the last day of a month" do
    subject { Lock.new( Chronic.parse( "1979-01-31 23:00" ), Chronic.parse( "1979-02-1 01:00" ), @user ) }
    it { should be_shortened_into( "[yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00" ) }
  end


  context "when its duration crosses a new year's day" do
    subject { Lock.new( Chronic.parse( "1978-12-31 23:00" ), Chronic.parse( "1979-01-01 01:00" ), @user ) }
    it { should be_shortened_into( "[yutaro] 1978/12/31 (Sun) 23:00 - 1979/01/01 (Mon) 01:00" ) }
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
