
require 'date'
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimecopInternals < Test::Unit::TestCase
  
  def test_parse_travel_args_with_time
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    ty, tm, td, th, tmin, ts = Timecop.instance().send(:parse_travel_args, t)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end

  def test_parse_travel_args_with_datetime
    t = DateTime.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    ty, tm, td, th, tmin, ts = Timecop.instance().send(:parse_travel_args, t)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end

  def test_parse_travel_args_with_date
    date = Date.today
    y, m, d, h, min, s = date.year, date.month, date.day, 0, 0, 0
    ty, tm, td, th, tmin, ts = Timecop.instance().send(:parse_travel_args, date)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end

  # Due to the nature of this test (calling Time.now once in this test and
  # once in #parse_travel_args), this test may fail when two subsequent calls
  # to Time.now return a different second.
  def test_parse_travel_args_with_integer
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    ty, tm, td, th, tmin, ts = Timecop.instance().send(:parse_travel_args, 0)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end

  def test_parse_travel_args_with_individual_arguments
    y, m, d, h, min, s = 2008, 10, 10, 10, 10, 10
    ty, tm, td, th, tmin, ts = Timecop.instance().send(:parse_travel_args, y, m, d, h, min, s)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end
end