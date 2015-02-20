require File.join(File.dirname(__FILE__), "test_helper")
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimecop < Minitest::Unit::TestCase
  def setup
    t = Time.local(2008, 9, 1, 10, 5, 0) # monday
    Timecop.travel(t)
  end

  def teardown
    Timecop.return
  end


  def parse_sunday_after_travel(klass)
    assert_equal klass.parse("2008-08-31"), klass.parse('Sunday')
  end

  def parse_monday_after_travel(klass)
    assert_equal klass.parse("2008-09-01"), klass.parse('Monday')
  end

  def parse_tuesday_after_travel(klass)
    assert_equal klass.parse("2008-09-02"), klass.parse('Tuesday')
  end

  def parse_wednesday_after_travel(klass)
    assert_equal klass.parse("2008-09-03"), klass.parse('Wednesday')
  end

  def parse_thursday_after_travel(klass)
    assert_equal klass.parse("2008-09-04"), klass.parse('Thursday')
  end

  def parse_friday_after_travel(klass)
    assert_equal klass.parse("2008-09-05"), klass.parse('Friday')
  end

  def parse_saturday_after_travel(klass)
    assert_equal klass.parse("2008-09-06"), klass.parse('Saturday')
  end

  def parse_with_additional_args(klass)
    assert_equal klass.parse("2008-09-06", false), klass.parse('Saturday')
  end

  def parse_nil(klass)
    assert_raises ::TypeError do
      klass.parse(nil)
    end
  end

  def run_all_test_for_klass(klass)
    parse_sunday_after_travel(klass)
    parse_monday_after_travel(klass)
    parse_tuesday_after_travel(klass)
    parse_wednesday_after_travel(klass)
    parse_thursday_after_travel(klass)
    parse_friday_after_travel(klass)
    parse_saturday_after_travel(klass)
    parse_with_additional_args(klass)
    parse_nil(klass)
  end

  def test_date_klass
    run_all_test_for_klass(Date)
  end

  def test_date_time_klass
    run_all_test_for_klass(DateTime)
  end
end
