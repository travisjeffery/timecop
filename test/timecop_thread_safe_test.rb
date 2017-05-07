require_relative "test_helper"
require 'timecop'

class TestTimecop < Minitest::Test
  def teardown
    Timecop.thread_safe = false
    Thread.current[:timecop_instance] = nil
  end

  def test_thread_safe
    Timecop.thread_safe = true
    tc = Timecop.instance
    assert_equal Thread.current[:timecop_instance], tc
  end

  def test_thread_unsafe
    tc = Timecop.instance
    assert_equal Thread.current[:timecop_instance], nil
  end
end
