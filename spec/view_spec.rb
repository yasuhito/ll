require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe View do
  it "should show locks with index" do
    from0 = Chronic.parse( "1979-05-27 05:00" )
    lock0 = Lock.new( from0, from0 + 3600, "yasuhito" )

    from1 = Chronic.parse( "1979-01-31 23:00" )
    lock1 = Lock.new( from1, from1 + 7200, "yasuhito" )

    messenger = StringIO.new
    View.new( messenger ).show_with_index "tick001", [ lock0, lock1 ]
    messenger.string.should == <<-EOF
tick001:
  0) [yasuhito] 1979/05/27 (Sun) 05:00 - 06:00
  1) [yasuhito] 1979/01/31 (Wed) 23:00 - 02/01 (Thu) 01:00
EOF
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
