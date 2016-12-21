require 'date'

require 'bundler/setup'
require 'active_support/all'

require_relative "test_helper"
require 'timecop'

class TestTimecopWithActiveSupport < Minitest::Test
  def teardown
    Timecop.return
  end

  def test_travel_does_not_reduce_precision_of_time
    Timecop.travel(1)
    long_ago = Time.now
    sleep(0.000001)
    diff = long_ago.nsec - Time.now.nsec
    assert_equal 0, diff, "Expected zero difference but was #{diff}"
  end
end
