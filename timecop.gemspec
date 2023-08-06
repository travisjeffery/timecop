require File.expand_path('../lib/timecop/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{timecop}
  s.version = Timecop::VERSION
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.authors = ["Travis Jeffery", "John Trupiano"]
  s.description = %q{A gem providing "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.  It provides a unified method to mock Time.now, Date.today, and DateTime.now in a single call.}
  s.email = %q{travisjeffery@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "lib/timecop.rb",
    "lib/timecop/time_extensions.rb",
    "lib/timecop/time_stack_item.rb",
    "lib/timecop/version.rb",
    "lib/timecop/timecop.rb"
  ]
  s.homepage = %q{https://github.com/travisjeffery/timecop}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{A gem providing "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.  It provides a unified method to mock Time.now, Date.today, and DateTime.now in a single call.}
  s.license = "MIT"
end
