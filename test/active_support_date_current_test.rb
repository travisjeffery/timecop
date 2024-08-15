require_relative "test_helper"
require 'timecop'
require 'active_support'
require 'active_support/core_ext/date/calculations'

class TestActiveSupportDateCurrent < Minitest::Test
  def test_date_current_same_as_date_today_with_time_zone
    puts "Before Timecop.freeze"
    puts "ENV['TZ']: #{ENV['TZ']}"
    puts "Time.zone: #{Time.zone}"
    puts

    old_zone = Time.zone
    begin
      Time.zone = "UTC"
      Timecop.freeze("2024-03-15") do
        puts "Within Timecop.freeze"
        puts "ENV['TZ']: #{ENV['TZ']}"
        puts "Time.zone: #{Time.zone}"

        assert_equal Date.current, Date.today
      end
    ensure
      Time.zone = old_zone
    end
  end
end