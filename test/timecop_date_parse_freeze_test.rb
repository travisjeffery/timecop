require_relative "test_helper"
require 'timecop'
require_relative 'date_parse_scenarios'
require_relative 'date_time_parse_scenarios'

class TestTimecop < Minitest::Test
  def setup
    t = Time.local(2008, 9, 1, 10, 5, 0) # monday
    Timecop.freeze(t)
  end

  def teardown
    Timecop.return
  end

  # Test for Date
  include DateParseScenarios
  # Tests for DateTime
  include DateTimeParseScenarios
end
