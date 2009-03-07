# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{timecop}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Trupiano"]
  s.date = %q{2009-03-06}
  s.description = %q{A gem providing simple ways to temporarily override Time.now, Date.today, and DateTime.now.  It provides "time travel" capabilities, making it dead simple to test time-dependent code.}
  s.email = %q{jtrupiano@gmail.com}
  s.files = ["History.txt", "Manifest.txt", "Rakefile", "README.textile", "VERSION.yml", "lib/timecop", "lib/timecop/stack_item.rb", "lib/timecop/time_extensions.rb", "lib/timecop/timecop.rb", "lib/timecop/version.rb", "lib/timecop.rb", "test/run_tests.sh", "test/test_timecop.rb", "test/test_timecop_internals.rb", "test/test_timecop_without_date.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jtrupiano/timecop}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{johntrupiano}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A gem providing simple ways to temporarily override Time.now, Date.today, and DateTime.now.  It provides "time travel" capabilities, making it dead simple to test time-dependent code.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
