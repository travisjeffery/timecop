require 'date'
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimeStackItem < Test::Unit::TestCase
  
  def test_new_with_time
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    stack_item = Timecop::TimeStackItem.new(:freeze, t)
    assert_equal y,   stack_item.year
    assert_equal m,   stack_item.month
    assert_equal d,   stack_item.day
    assert_equal h,   stack_item.hour
    assert_equal min, stack_item.min
    assert_equal s,   stack_item.sec
  end

  def test_new_with_datetime_now
    t = DateTime.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    stack_item = Timecop::TimeStackItem.new(:freeze, t)
    assert_equal y,   stack_item.year
    assert_equal m,   stack_item.month
    assert_equal d,   stack_item.day
    assert_equal h,   stack_item.hour
    assert_equal min, stack_item.min
    assert_equal s,   stack_item.sec
  end
  
  def test_new_with_datetime_in_different_timezone
    t = DateTime.parse("2009-10-11 00:38:00 +0200")
    stack_item = Timecop::TimeStackItem.new(:freeze, t)
    assert_equal t, stack_item.datetime
  end

  def test_new_with_date
    date = Date.today
    y, m, d, h, min, s = date.year, date.month, date.day, 0, 0, 0
    stack_item = Timecop::TimeStackItem.new(:freeze, date)
    assert_equal y,   stack_item.year
    assert_equal m,   stack_item.month
    assert_equal d,   stack_item.day
    assert_equal h,   stack_item.hour
    assert_equal min, stack_item.min
    assert_equal s,   stack_item.sec
  end

  # Due to the nature of this test (calling Time.now once in this test and
  # once in #new), this test may fail when two subsequent calls
  # to Time.now return a different second.
  def test_new_with_integer
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    stack_item = Timecop::TimeStackItem.new(:freeze, 0)
    assert_equal y,   stack_item.year
    assert_equal m,   stack_item.month
    assert_equal d,   stack_item.day
    assert_equal h,   stack_item.hour
    assert_equal min, stack_item.min
    assert_equal s,   stack_item.sec
  end

  def test_new_with_individual_arguments
    y, m, d, h, min, s = 2008, 10, 10, 10, 10, 10
    stack_item = Timecop::TimeStackItem.new(:freeze, y, m, d, h, min, s)
    assert_equal y,   stack_item.year
    assert_equal m,   stack_item.month
    assert_equal d,   stack_item.day
    assert_equal h,   stack_item.hour
    assert_equal min, stack_item.min
    assert_equal s,   stack_item.sec
  end
  
  def test_rational_to_utc_offset
    assert_equal -14400, a_time_stack_item.send(:rational_to_utc_offset, Rational(-1, 6))
    assert_equal -18000, a_time_stack_item.send(:rational_to_utc_offset, Rational(-5, 24))
    assert_equal 0,      a_time_stack_item.send(:rational_to_utc_offset, Rational(0, 1))
    assert_equal 3600,   a_time_stack_item.send(:rational_to_utc_offset, Rational(1, 24))
  end
  
  def test_utc_offset_to_rational
    assert_equal Rational(-1, 6),  a_time_stack_item.send(:utc_offset_to_rational, -14400)
    assert_equal Rational(-5, 24), a_time_stack_item.send(:utc_offset_to_rational, -18000)
    assert_equal Rational(0, 1),   a_time_stack_item.send(:utc_offset_to_rational, 0)
    assert_equal Rational(1, 24),  a_time_stack_item.send(:utc_offset_to_rational, 3600)
  end
  
  private
    def a_time_stack_item
      Timecop::TimeStackItem.new(:freeze, 2008, 1, 1, 0, 0, 0)
    end
end