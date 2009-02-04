
require 'date'
require 'test/unit'
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
      assert_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
      assert_equal Date.new(2008, 10, 10), Date.today
    end
    assert_not_equal t, Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end
  
  def test_freeze_with_datetime_instance_works_as_expected
    t = DateTime.new(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do 
      assert_equal t, DateTime.now
      assert_equal Time.local(2008, 10, 10, 10, 10, 10), Time.now
      assert_equal Date.new(2008, 10, 10), Date.today
    end
    assert_not_equal t, DateTime.now
    assert_not_equal Time.local(2008, 10, 10, 10, 10, 10), Time.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end
  
  def test_freeze_with_date_instance_works_as_expected
    d = Date.new(2008, 10, 10)
    Timecop.freeze(d) do
      assert_equal d, Date.today
      assert_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
      assert_equal DateTime.new(2008, 10, 10, 0, 0, 0), DateTime.now
    end
    assert_not_equal d, Date.today
    assert_not_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 0, 0, 0), DateTime.now    
  end
  
  def test_freeze_with_integer_instance_works_as_expected
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do
      assert_equal t, Time.now
      assert_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
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
      #assert Time.now < now, "If we had failed to freeze, time would have proceeded, which is what appears to have happened."
      assert Time.now - t < 2000, "Looks like we failed to actually travel time" # 2 seconds
      new_t = Time.now
      #sleep(10)
      assert_not_equal new_t, Time.now
    end
  end
  
  def test_recursive_rebasing_maintains_each_context
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.travel(2008, 10, 10, 10, 10, 10) do 
      assert((t - Time.now).abs < 50, "Failed to travel time.")
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.travel(2008, 9, 9, 9, 9, 9) do
        assert((t2 - Time.now) < 50, "Failed to travel time.")
        assert((t - Time.now) > 1000, "Failed to travel time.")
      end
      assert((t - Time.now).abs < 2000, "Failed to restore previously-traveled time.")
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
      assert((t - Time.now).abs < 2000, "Failed to restore previously-traveled time.")
    end
    assert_nil Time.send(:mock_time)
  end
  
  def test_recursive_freeze_then_travel
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.freeze(t) do 
      assert_equal t, Time.now
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.travel(t2) do
        assert((t2 - Time.now) < 50, "Failed to travel time.")
        assert((t - Time.now) > 1000, "Failed to travel time.")
      end
      assert_equal t, Time.now
    end
    assert_nil Time.send(:mock_time)    
  end
  
end