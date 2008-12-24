
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimecopWithouDate < Test::Unit::TestCase
  
  def setup
    assert !Object.const_defined?(:Date)
    assert !Object.const_defined?(:DateTime)
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
    assert_nil Time.send(:mock_time)
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
      new_t = Time.now
      assert_equal t, new_t, "Failed to change move time." # 2 seconds
      #sleep(10)
      assert_equal new_t, Time.now
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