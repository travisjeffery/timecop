require_relative "test_helper"
require 'timecop'
require_relative 'date_strptime_scenarios'

class TestTimecop < Minitest::Test
  def setup
    t = Time.local(1984,2,28)
    Timecop.freeze(t)
  end

  def teardown
    Timecop.return
  end

  # Test for Date
  include DateStrptimeScenarios

end
