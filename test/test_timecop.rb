
require 'date'
require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')

class TestTimecop < Test::Unit::TestCase
  
  def setup
    
  end
  
  # just in case...let's really make sure that Timecop is disabled between tests...
  def teardown
    Timecop.unset_all
  end
  
  def test_travel_changes_and_resets_time
    # depending on how we're invoked (individually or via the rake test suite)
    assert !Time.respond_to?(:zone) || Time.zone.nil?
    
    t = Time.local(2008, 10, 10, 10, 10, 10)
    assert_not_equal t, Time.now
    Timecop.travel(2008, 10, 10, 10, 10, 10) do
      assert_equal t, Time.now
    end
    assert_not_equal t, Time.now
  end
  
  def test_recursive_travel
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.travel(2008, 10, 10, 10, 10, 10) do 
      assert_equal t, Time.now
      t2 = Time.local(2008, 9, 9, 9, 9, 9)
      Timecop.travel(2008, 9, 9, 9, 9, 9) do
        assert_equal t2, Time.now
      end
      assert_equal t, Time.now
    end
    assert_nil Time.send(:mock_time)
  end
  
  def test_travel_with_time_instance_works_as_expected
    t = Time.local(2008, 10, 10, 10, 10, 10)
    Timecop.travel(t) do 
      assert_equal t, Time.now
      assert_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
      assert_equal Date.new(2008, 10, 10), Date.today
    end
    assert_not_equal t, Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 10, 10, 10), DateTime.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end
  
  def test_travel_with_datetime_instance_works_as_expected
    t = DateTime.new(2008, 10, 10, 10, 10, 10)
    Timecop.travel(t) do 
      assert_equal t, DateTime.now
      assert_equal Time.local(2008, 10, 10, 10, 10, 10), Time.now
      assert_equal Date.new(2008, 10, 10), Date.today
    end
    assert_not_equal t, DateTime.now
    assert_not_equal Time.local(2008, 10, 10, 10, 10, 10), Time.now
    assert_not_equal Date.new(2008, 10, 10), Date.today
  end
  
  def test_travel_with_date_instance_works_as_expected
    d = Date.new(2008, 10, 10)
    Timecop.travel(d) do
      assert_equal d, Date.today
      assert_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
      assert_equal DateTime.new(2008, 10, 10, 0, 0, 0), DateTime.now
    end
    assert_not_equal d, Date.today
    assert_not_equal Time.local(2008, 10, 10, 0, 0, 0), Time.now
    assert_not_equal DateTime.new(2008, 10, 10, 0, 0, 0), DateTime.now    
  end
  
  def test_exception_thrown_in_travel_block_properly_resets_time
    t = Time.local(2008, 10, 10, 10, 10, 10)
    begin
      Timecop.travel(t) do
        assert_equal t, Time.now
        raise "blah exception"
      end
    rescue
      assert_not_equal t, Time.now
      assert_nil Time.send(:mock_time)
    end
  end
  
  
  def test_parse_travel_args_with_time
    t = Time.now
    y, m, d, h, min, s = t.year, t.month, t.day, t.hour, t.min, t.sec
    ty, tm, td, th, tmin, ts = Timecop.send(:parse_travel_args, t)
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
    ty, tm, td, th, tmin, ts = Timecop.send(:parse_travel_args, t)
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
    ty, tm, td, th, tmin, ts = Timecop.send(:parse_travel_args, date)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end
  
  def test_parse_travel_args_with_individual_arguments
    y, m, d, h, min, s = 2008, 10, 10, 10, 10, 10
    ty, tm, td, th, tmin, ts = Timecop.send(:parse_travel_args, y, m, d, h, min, s)
    assert_equal y, ty
    assert_equal m, tm
    assert_equal d, td
    assert_equal h, th
    assert_equal min, tmin
    assert_equal s, ts
  end
end