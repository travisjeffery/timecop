require 'date'
require File.join(File.dirname(__FILE__), "test_helper")
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimeStackItem < Test::Unit::TestCase
  def teardown
    Timecop.active_support = nil
    Timecop.return
  end

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

  def test_new_with_time_and_arguments
    t = Time.new(2012, 7, 28, 20, 0)
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
    each_timezone do
      t = DateTime.parse("2009-10-11 00:38:00 +0200")
      stack_item = Timecop::TimeStackItem.new(:freeze, t)

      assert_date_times_equal(t, stack_item.datetime)
    end
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

  def test_compute_dst_adjustment_for_dst_to_dst
    Timecop.freeze(DateTime.parse("2009-10-1 00:38:00 -0400"))
    t = DateTime.parse("2009-10-11 00:00:00 -0400")
    tsi = Timecop::TimeStackItem.new(:freeze, t)
    return if !(Time.now.dst? && tsi.time.dst?)

    assert_equal 0, tsi.send(:dst_adjustment)
  end

  def test_compute_dst_adjustment_for_non_dst_to_non_dst
    Timecop.freeze(DateTime.parse("2009-12-1 00:38:00 -0400"))
    t = DateTime.parse("2009-12-11 00:00:00 -0400")
    tsi = Timecop::TimeStackItem.new(:freeze, t)
    return if Time.now.dst? || tsi.time.dst?

    assert_equal 0, tsi.send(:dst_adjustment)
  end

  def test_compute_dst_adjustment_for_dst_to_non_dst
    Timecop.freeze(DateTime.parse("2009-10-1 00:38:00 -0400"))
    t = DateTime.parse("2009-12-11 00:00:00 -0400")
    tsi = Timecop::TimeStackItem.new(:freeze, t)
    return if !Time.now.dst? || tsi.time.dst?

    assert_equal 60 * 60, tsi.send(:dst_adjustment)
  end

  def test_compute_dst_adjustment_for_non_dst_to_dst
    Timecop.freeze(DateTime.parse("2009-12-1 00:38:00 -0400"))
    t = DateTime.parse("2009-10-11 00:00:00 -0400")
    tsi = Timecop::TimeStackItem.new(:freeze, t)
    return if Time.now.dst? || !tsi.time.dst?

    assert_equal -1 * 60 * 60, tsi.send(:dst_adjustment)
  end

  # Ensure DateTimes handle changing DST properly
  def test_datetime_for_dst_to_non_dst
    Timecop.freeze(DateTime.parse("2009-12-1 00:38:00 -0500"))
    t = DateTime.parse("2009-10-11 00:00:00 -0400")
    tsi = Timecop::TimeStackItem.new(:freeze, t)

    assert_date_times_equal t, tsi.datetime
  end

  def test_datetime_for_non_dst_to_dst
    Timecop.freeze(DateTime.parse("2009-10-11 00:00:00 -0400"))
    t = DateTime.parse("2009-11-30 23:38:00 -0500")
    tsi = Timecop::TimeStackItem.new(:freeze, t)
    return if !tsi.time.dst?

    assert_date_times_equal t, tsi.datetime
    assert_equal Date.new(2009, 12, 1), tsi.date
  end

  def test_set_travel_offset_for_travel
    t_now = Time.now
    t = Time.local(2009, 10, 1, 0, 0, 30)
    expected_offset = t - t_now
    tsi = Timecop::TimeStackItem.new(:travel, t)

    assert_times_effectively_equal expected_offset, tsi.send(:travel_offset), 1, "Offset not calculated correctly"
  end

  def test_set_travel_offset_for_freeze
    Timecop.freeze(2009, 10, 1, 0, 0, 0)
    t = Time.local(2009, 10, 1, 0, 0, 30)
    tsi = Timecop::TimeStackItem.new(:freeze, t)

    assert_equal nil, tsi.send(:travel_offset)
  end

  def test_timezones
    require 'active_support/all'
    Time.zone = "Europe/Zurich"
    time = Time.zone.parse("2012-12-27T12:12:12+08:00")
    Timecop.freeze(time) do |frozen_time|
      assert_equal time, frozen_time
    end
  end

  def test_timezones_apply_dates
    require 'active_support/all'
    Time.zone = "Marshall Is."
    time = Time.zone.local(2013,1,3)

    Timecop.freeze(time) do
      assert_equal time.to_date, Date.today
    end
  end

  def test_set_scaling_factor_for_scale
    t_now = Time.now
    t = Time.local(2009, 10, 1, 0, 0, 30)
    expected_offset = t - t_now
    tsi = Timecop::TimeStackItem.new(:scale, 4, t)

    assert_times_effectively_equal expected_offset, tsi.send(:travel_offset), 1, "Offset not calculated correctly"
    assert_equal tsi.send(:scaling_factor), 4, "Scaling factor not set"
  end

  def test_parse_string_date_with_active_support
    date = '2012-01-02'
    Time.expects(:parse).with(date).returns(Time.local(2012, 01, 02))
    Timecop.freeze(date)
  end

  def test_parse_only_string_with_active_support
    Time.expects(:parse).never
    Timecop.freeze(2011, 01, 02, hour=0, minute=0, second=0)
  end

  def test_parse_with_active_support_off
    date = '2012-01-02'
    Timecop.active_support = false
    Time.expects(:parse).never
    Timecop.freeze(date)
  end

  def test_uses_active_supports_in_time_zone
    time = Time.now
    Time.any_instance.expects(:in_time_zone).returns(time)
    Timecop::TimeStackItem.new(:freeze, time)
  end

  def test_configured_off_active_support_in_time_zone_xxx
    Timecop.active_support = false
    Time.any_instance.expects(:in_time_zone).never
    Timecop::TimeStackItem.new(:freeze, Time.now)
  end

  def test_parse_date
    assert_nothing_raised do
      Timecop.freeze(Date.new(2012, 6, 9))
    end
  end

  def test_time_zone_returns_nil
    c = class << Time; self end
    c.send(:define_method, :zone) { nil }
    assert_nothing_raised do
      Timecop.freeze
    end
  end

  def test_nsecs_are_set
    time = Time.now
    Timecop.freeze time
    assert_equal time, Time.now
    assert_equal time.nsec, Time.now.nsec if (Time.now.respond_to?(:nsec))
  end

  def test_time_with_different_timezone
    require 'active_support/all'

    Time.zone = "Tokyo"
    t = Time.now
    Timecop.freeze(t) do
      assert_times_effectively_equal t, Time.now
    end
  end
end
