#
# Lock with expiration date.
#
#  Lock.new( Chronic.parse( "1979-05-27 05:00" ),
#            Chronic.parse( "1979-05-27 06:00" ),
#            "yutaro" ).to_s
#  #=> "[yutaro] 1979/05/27 (Sun) 05:00 - 06:00"
#
class Lock
  TIME_FORMAT_LONG = "%Y/%m/%d (%a) %H:%M"
  TIME_FORMAT_MEDIUM = "%m/%d (%a) %H:%M"
  TIME_FORMAT_SHORT = "%H:%M"


  attr_reader :from
  attr_reader :to
  attr_reader :user


  def initialize from, to, user
    @from = from
    @to = to
    @user = user
  end


  def duration
    @to - @from
  end


  def obsolete?
    @to < Time.now
  end


  def conflict_with other
    overwrap_with( other ) && @user != other.user
  end


  def overwrap_with other
    not ( @to < other.from || other.to < @from )
  end


  def == other
    @from == other.from && @to == other.to
  end


  def <=> other
    @from <=> other.from
  end


  def to_s
    "[#{ @user }] #{ format_from } - #{ format_to }"
  end


  def to_json *args
    {
      "json_class" => self.class.name,
      "data" => { :user => @user, :from => @from, :to => @to },
    }.to_json( *args )
  end


  def inspect
    "#<Lock:#{__id__} #{ to_s }>"
  end


  ##############################################################################
  private
  ##############################################################################


  def format_from
    @from.strftime TIME_FORMAT_LONG
  end


  def format_to
    if fit_within_a_day?
      @to.strftime TIME_FORMAT_SHORT
    elsif fit_within_a_year?
      @to.strftime TIME_FORMAT_MEDIUM
    else
      @to.strftime TIME_FORMAT_LONG
    end
  end


  def fit_within_a_day?
    compare_from_to_in "%Y/%m/%d"
  end


  def fit_within_a_year?
    compare_from_to_in "%Y"
  end


  def compare_from_to_in format
    @from.strftime( format ) == @to.strftime( format )
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
