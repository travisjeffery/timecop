require 'date'
require 'active_support/all'

require File.join(File.dirname(__FILE__), "test_helper")
require File.join(File.dirname(__FILE__), '..', 'lib', 'timecop')


class TestTimecopWithActiveSupport < Test::Unit::TestCase
  def teardown
    Timecop.return
  end

  def test_travel_does_not_reduce_precision_of_time
    Timecop.travel(1)
    long_ago = Time.now
    sleep(0.000001)
    assert_not_equal long_ago.to_f, Time.now.to_f
  end

end
