require 'date'
require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimecop < Test::Unit::TestCase
  
  def setup
    
  end
  
  # just in case...let's really make sure that Timecop is disabled between tests...
  def teardown
    Timecop.return
  end
  
  def test_freeze_changes_and_resets_time
    # depending on how we're invoked (individually or via the rake test suite)
    assert !Time.respond_to?(:zone) || Time.zone.nil?
    
    t = Time.local(2008, 10, 10, 10, 10, 10)
    assert_not_equal t, Time.now
    Timecop.freeze(2008, 10, 10, 10, 10, 10) do
      assert_equal t, Time.now
    end
    assert_not_equal t, Time.now
  end
  
  def test_freeze_then_return_unsets_mock_time
    Timecop.freeze(1)
    Timecop.return
    assert_nil Time.send(:mock_time)
  end

  def test_travel_then_return_unsets_mock_time
    Timecop.travel(1)
    Timecop.return
    assert_nil Time.send(:mock_time)
  end
  
  def test_freeze_with_block_unsets_mock_time
    assert_nil Time.send(:mock_time), "test is invalid"
    Timecop.freeze(1) do; end
    assert_nil Time.send(:mock_time)
  end
  
  def test_travel_with_block_unsets_mock_time
    assert_nil Time.send(:mock_time), "test is invalid"
    Timecop.travel(1) do; end
    assert_nil Time.send(:mock_time)
  end
  
  def test_recursive_freeze
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(2008, 10, 10, 10, 10, 10) do 
      assert_equal t, Time.now
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.freeze(2008, 9, 9, 9, 9, 9) do
        assert_equal t2, Time.now
      end
      assert_equal t, Time.now
    end
    assert_not_equal t, Time.now
  end
  
  def test_freeze_with_time_instance_works_as_expected
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do 
      assert_equal t, Time.now
      assert_date_times_equal DateTime.new(2008, 10, 10, 10, 10, 10, local_offset), DateTime.now
      assert_equal Date.new(2008, 10, 10), Date.today
    end
    assert_not_equal t, Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 10, 10, 10, local_offset), DateTime.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end
  
  def test_freeze_with_datetime_on_specific_timezone_during_dst
    each_timezone do
      # Start from a time that is subject to DST
      Timecop.freeze(2009, 9, 1)
      # Travel to a DateTime that is also in DST
      t = DateTime.parse("2009-10-11 00:38:00 +0200")
      Timecop.freeze(t) do
        assert_date_times_equal t, DateTime.now
      end
      # Undo the original freeze
      Timecop.return
    end
  end
  
  def test_freeze_with_datetime_on_specific_timezone_not_during_dst
    each_timezone do
      # Start from a time that is not subject to DST
      Timecop.freeze(2009, 12, 1)
      # Travel to a time that is also not in DST
      t = DateTime.parse("2009-12-11 00:38:00 +0100")
      Timecop.freeze(t) do
        assert_date_times_equal t, DateTime.now
      end
    end
  end
  
  def test_freeze_with_datetime_from_a_non_dst_time_to_a_dst_time
    each_timezone do
      # Start from a time that is not subject to DST
      Timecop.freeze(DateTime.parse("2009-12-1 00:00:00 +0100"))
      # Travel back to a time in DST
      t = DateTime.parse("2009-10-11 00:38:00 +0200")
      Timecop.freeze(t) do
        assert_date_times_equal t, DateTime.now
      end
    end    
  end

  def test_freeze_with_datetime_from_a_dst_time_to_a_non_dst_time
    each_timezone do
      # Start from a time that is not subject to DST
      Timecop.freeze(DateTime.parse("2009-10-11 00:00:00 +0200"))
      # Travel back to a time in DST
      t = DateTime.parse("2009-12-1 00:38:00 +0100")
      Timecop.freeze(t) do
        assert_date_times_equal t, DateTime.now
      end
    end    
  end
  
  def test_freeze_with_date_instance_works_as_expected
    d = Date.new(2008, 10, 10)
    Timecop.freeze(d) do
      assert_equal d, Date.today
      assert_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
      assert_date_times_equal DateTime.new(2008, 10, 10, 0, 0, 0, local_offset), DateTime.now
    end
    assert_not_equal d, Date.today
    assert_not_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 0, 0, 0, local_offset), DateTime.now    
  end
  
  def test_freeze_with_integer_instance_works_as_expected
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do
      assert_equal t, Time.now
      assert_date_times_equal DateTime.new(2008, 10, 10, 10, 10, 10, local_offset), DateTime.now
      assert_equal Date.new(2008, 10, 10), Date.today
      Timecop.freeze(10) do
        assert_equal t + 10, Time.now
        assert_equal Time.local(2008, 10, 10, 10, 10, 20), Time.now
        assert_equal Date.new(2008, 10, 10), Date.today
      end
    end
    assert_not_equal t, Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end

  def test_exception_thrown_in_freeze_block_properly_resets_time
    t = Time.local(2008, 10, 10, 10, 10, 10)
    begin
      Timecop.freeze(t) do
        assert_equal t, Time.now
        raise "blah exception"
      end
    rescue
      assert_not_equal t, Time.now
      assert_nil Time.send(:mock_time)
    end
  end
  
  def test_freeze_freezes_time
    t = Time.local(2008, 10, 10, 10, 10, 10)
    now = Time.now
    Timecop.freeze(t) do
      #assert Time.now < now, "If we had failed to freeze, time would have proceeded, which is what appears to have happened."
      new_t, new_d, new_dt = Time.now, Date.today, DateTime.now
      assert_equal t, new_t, "Failed to freeze time." # 2 seconds
      #sleep(10)
      assert_equal new_t, Time.now
      assert_equal new_d, Date.today
      assert_equal new_dt, DateTime.now
    end
  end
  
  def test_travel_keeps_time_moving
    t = Time.local(2008, 10, 10, 10, 10, 10)
    now = Time.now
    Timecop.travel(t) do
      new_now = Time.now
      assert_times_effectively_equal(new_now, t, 1, "Looks like we failed to actually travel time")
      sleep(0.25)
      assert_times_effectively_not_equal new_now, Time.now, 0.25, "Looks like time is not moving"
    end
  end
  
  def test_mocked_date_time_now_is_local
    each_timezone do
      t = DateTime.parse("2009-10-11 00:38:00 +0200")
      Timecop.freeze(t) do
        assert_equal local_offset, DateTime.now.offset, "Failed for timezone: #{ENV['TZ']}"
      end
    end
  end
  
  def test_freeze_with_utc_time
    each_timezone do
      t = Time.utc(2008, 10, 10, 10, 10, 10)
      local = t.getlocal
      Timecop.freeze(t) do
        assert_equal local, Time.now, "Failed for timezone: #{ENV['TZ']}"
      end
    end
  end

  def test_destructive_methods_on_frozen_time
    # Use any time zone other than UTC.
    ENV['TZ'] = 'EST'

    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do
      assert !Time.now.utc?, "Time#local failed to return a time in the local time zone."

      # #utc, #gmt, and #localtime are destructive methods.
      Time.now.utc

      assert !Time.now.utc?, "Failed to thwart destructive methods."
    end
  end
  
  def test_recursive_travel_maintains_each_context
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.travel(2008, 10, 10, 10, 10, 10) do 
      assert((t - Time.now).abs < 50, "Failed to travel time.")
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.travel(2008, 9, 9, 9, 9, 9) do
        assert_times_effectively_equal(t2, Time.now, 1, "Failed to travel time.")
        assert_times_effectively_not_equal(t, Time.now, 1000, "Failed to travel time.")
      end
      assert_times_effectively_equal(t, Time.now, 2, "Failed to restore previously-traveled time.")
    end
    assert_nil Time.send(:mock_time)
  end
  
  def test_recursive_travel_then_freeze
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.travel(2008, 10, 10, 10, 10, 10) do 
      assert((t - Time.now).abs < 50, "Failed to travel time.")
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.freeze(2008, 9, 9, 9, 9, 9) do
        assert_equal t2, Time.now
      end
      assert_times_effectively_equal(t, Time.now, 2, "Failed to restore previously-traveled time.")
    end
    assert_nil Time.send(:mock_time)
  end
  
  def test_recursive_freeze_then_travel
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do 
      assert_equal t, Time.now
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.travel(t2) do
        assert_times_effectively_equal(t2, Time.now, 1, "Failed to travel time.")
        assert_times_effectively_not_equal(t, Time.now, 1000, "Failed to travel time.")
      end
      assert_equal t, Time.now
    end
    assert_nil Time.send(:mock_time)    
  end
  
  def test_return_values_are_Time_instances
    assert Timecop.freeze.is_a?(Time)
    assert Timecop.travel.is_a?(Time)
    assert Timecop.return.is_a?(Time)
  end
  
  def test_travel_time_returns_passed_value
    t_future = Time.local(2030, 10, 10, 10, 10, 10)
    t_travel = Timecop.travel t_future
    assert times_effectively_equal(t_future, t_travel)
  end
  
  def test_freeze_time_returns_passed_value
    t_future = Time.local(2030, 10, 10, 10, 10, 10)
    t_frozen = Timecop.freeze t_future
    assert times_effectively_equal(t_future, t_frozen)
  end
  
  def test_return_time_returns_actual_time
    t_real = Time.now
    Timecop.freeze Time.local(2030, 10, 10, 10, 10, 10)
    t_return = Timecop.return
    assert times_effectively_equal(t_real, t_return)
  end

end