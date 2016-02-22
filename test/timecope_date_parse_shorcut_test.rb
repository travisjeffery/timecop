require_relative "test_helper"
require 'timecop'

class TestTimecop < Minitest::Test
  def setup
    t = Time.local(2008, 9, 1, 10, 5, 0) # monday
    Timecop.travel(t)
  end

  def teardown
    Timecop.return
  end

  # Test for Date
  def test_date_parse_sunday_after_travel
    assert_equal Date.parse("2008-08-31"), Date.parse('Sun')
  end

  def test_date_parse_monday_after_travel
    assert_equal Date.parse("2008-09-01"), Date.parse('Mon')
  end

  def test_date_parse_tuesday_after_travel
    assert_equal Date.parse("2008-09-02"), Date.parse('Tue')
  end

  def test_date_parse_wednesday_after_travel
    assert_equal Date.parse("2008-09-03"), Date.parse('Wed')
  end

  def test_date_parse_thursday_after_travel
    assert_equal Date.parse("2008-09-04"), Date.parse('Thu')
  end

  def test_date_parse_friday_after_travel
    assert_equal Date.parse("2008-09-05"), Date.parse('Fri')
  end

  def test_date_parse_saturday_after_travel
    assert_equal Date.parse("2008-09-06"), Date.parse('Sat')
  end

  def test_date_parse_with_additional_args
    assert_equal Date.parse("2008-09-06", false), Date.parse('Sat')
  end

  def test_date_parse_october_10
    assert_equal Date.parse("2008-10-10"), Date.parse('October 10')
  end

  def test_date_parse_1010
    assert_equal Date.parse("2008-10-10"), Date.parse('1010')
  end

  def test_date_parse_10_slash_10
    assert_equal Date.parse("2008-10-10"), Date.parse('10/10')
  end

  def test_date_parse_Date_10_slash_10
    assert_equal Date.parse("2008-10-10"), Date.parse('Date 10/10')
  end

  def test_date_parse_nil_raises_type_error
    assert_raises(TypeError) { Date.parse(nil) }
  end

  # Tests for DateTime
  def test_date_time_parse_sunday_after_travel
    assert_equal DateTime.parse("2008-08-31"), DateTime.parse('Sun')
  end

  def test_date_time_parse_monday_after_travel
    assert_equal DateTime.parse("2008-09-01"), DateTime.parse('Mon')
  end

  def test_date_time_parse_tuesday_after_travel
    assert_equal DateTime.parse("2008-09-02"), DateTime.parse('Tue')
  end

  def test_date_time_parse_wednesday_after_travel
    assert_equal DateTime.parse("2008-09-03"), DateTime.parse('Wed')
  end

  def test_date_time_parse_thursday_after_travel
    assert_equal DateTime.parse("2008-09-04"), DateTime.parse('Thu')
  end

  def test_date_time_parse_friday_after_travel
    assert_equal DateTime.parse("2008-09-05"), DateTime.parse('Fri')
  end

  def test_date_time_parse_saturday_after_travel
    assert_equal DateTime.parse("2008-09-06"), DateTime.parse('Sat')
  end

  def test_date_time_parse_with_additional_args
    assert_equal DateTime.parse("2008-09-06", false), DateTime.parse('Sat')
  end

  def test_date_time_parse_october_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('October 10')
  end

  def test_date_time_parse_1010
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('1010')
  end

  def test_date_time_parse_10_slash_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('10/10')
  end

  def test_date_time_parse_Date_10_slash_10
    assert_equal DateTime.parse("2008-10-10"), DateTime.parse('Date 10/10')
  end

  def test_datetime_parse_nil_raises_type_error
    assert_raises(TypeError) { DateTime.parse(nil) }
  end
end
