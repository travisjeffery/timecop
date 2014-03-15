require 'bundler/setup'
Bundler.require(:default, :development)

require 'timecop'

RSpec.configure do |config|

  config.order = :rand
  config.color_enabled = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
end
