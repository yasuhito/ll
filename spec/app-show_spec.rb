require File.join( File.dirname( __FILE__ ), "spec_helper" )


describe AppShow do
  before :each do
    @data = "/tmp/ll.dat"
    FileUtils.rm_f @data
    @messenger = StringIO.new
    @app = AppShow.new( :messenger => @messenger )
    @app.parse [ "--data", @data ]
  end


  it "should list no lock" do
    @app.start
    @messenger.string.should be_empty
  end


  it "should list current locks" do
    File.open( @data, "w" ) do | dat |
      lock1 = Lock.new( Chronic.parse( "2020-05-27 05:00" ), Chronic.parse( "2020-05-27 06:00" ), "yutaro" )
      lock2 = Lock.new( Chronic.parse( "2020-05-27 08:00" ), Chronic.parse( "2020-05-27 09:00" ), "yasuhito" )
      dat.print Marshal.dump( "node001" => [ lock1, lock2 ], "node002" => [ lock1, lock2 ] )
    end

    @app.start
    @messenger.string.should == <<-EOF
node001:
  [yutaro] 2020/05/27 (Wed) 05:00 - 06:00
  [yasuhito] 2020/05/27 (Wed) 08:00 - 09:00
node002:
  [yutaro] 2020/05/27 (Wed) 05:00 - 06:00
  [yasuhito] 2020/05/27 (Wed) 08:00 - 09:00
EOF
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
