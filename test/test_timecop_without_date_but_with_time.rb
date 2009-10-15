require "test/unit"

class TestTimecopWithoutDateButWithTime < Test::Unit::TestCase
  TIMECOP_LIB = File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

  def test_loads_properly_when_time_is_required_instead_of_date
    assert_nothing_raised do
      require "time"
      require TIMECOP_LIB
    end
  end
end
