# When this test is running under 'bundle exec', it "helpfully" adds
# '-rbundler/setup' to RUBYOPT, which in turn loads the Date/DateTime classes
# (in some versions of Bundler.)  But the bug we're trying to test for here only
# occurs if timecop was loaded before Date/DateTime.  So we have to detect if
# 'date' was already loaded here and rip it out before running the test.
if Object.const_defined?(:Date) && Date.respond_to?(:today)
  Object.send(:remove_const, :Date)
  Object.send(:remove_const, :DateTime)
  $LOADED_FEATURES.select {|f| f =~ /date/ }.each {|f| $LOADED_FEATURES.delete(f) }
end

# Require timecop first, before anything else that would load 'date'
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')
require File.join(File.dirname(__FILE__), "test_helper")
require 'date'

class TestTimecopWithoutDate < Test::Unit::TestCase
  # just in case...let's really make sure that Timecop is disabled between tests...
  def teardown
    Timecop.return
  end

  def test_freeze_changes_and_resets_date
    t = Date.new(2008, 10, 10)
    assert_not_equal t, Date.today
    Timecop.freeze(2008, 10, 10) do
      assert_equal t, Date.today
    end
    assert_not_equal t, Date.today
  end

  def test_freeze_changes_and_resets_datetime
    t = DateTime.new(2008, 10, 10, 0, 0, 0, 0)
    assert_not_equal t, DateTime.now
    Timecop.freeze(t) do
      assert_date_times_equal t, DateTime.now
    end
    assert_not_equal t, DateTime.now
  end
end
