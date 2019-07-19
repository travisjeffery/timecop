require File.join(File.dirname(__FILE__), "timecop", "timecop")
require File.join(File.dirname(__FILE__), "timecop", "version")
require File.join(File.dirname(__FILE__), "timecop", "test_frameworks", "rspec")

TestFrameworks::RSpec.configure_metadata if defined?(RSpec)
