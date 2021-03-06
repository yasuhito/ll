require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe View do
  before :each do
    @lock_yasuhito = Lock.new( Chronic.parse( "1979-05-27 05:00" ),
                               Chronic.parse( "1979-05-27 06:00" ), "yasuhito" )
    @lock_yutaro = Lock.new( Chronic.parse( "1979-01-31 23:00" ),
                             Chronic.parse( "1979-02-1 01:00" ), "yutaro" )
    @messenger = StringIO.new
    @view = View.new( :text, :messenger => @messenger )
  end


  it "should show locks" do
    @view.show [ "tick001" ], "tick001" => [ @lock_yasuhito, @lock_yutaro ]
    @messenger.string.should == <<-EOF
tick001:
  [yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00
  [yasuhito] 1979/05/27 (Sun) 05:00 - 06:00
EOF
  end


  it "should show locks with index" do
    @view.show_locks_with_index [ "tick001" ], [ @lock_yasuhito, @lock_yutaro ]
    @messenger.string.should == <<-EOF
tick001:
  0) [yutaro] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00
  1) [yasuhito] 1979/05/27 (Sun) 05:00 - 06:00
EOF
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
