source "https://rubygems.org"
if RUBY_VERSION.start_with?('2.5')
  gem 'psych', '~> 3.0'
end
gemspec

group :development do
  gem 'rake'
  gem 'rack', '< 2.0.0', :platforms => [:ruby_19, :ruby_20, :ruby_21, :jruby_19]
  gem 'nokogiri'
  gem 'jeweler', '< 2.1.2'
  gem 'pry'
  gem 'mocha'
  gem 'activesupport'
  gem 'tzinfo'
  gem 'minitest'
  gem 'minitest-rg'
end
