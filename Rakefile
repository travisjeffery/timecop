require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

gem 'jeweler', '~> 1.2.1'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "timecop"
    s.rubyforge_project = 'johntrupiano' # if different than lowercase project name
    s.description = %q(A gem providing "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.  It provides a unified method to mock Time.now, Date.today, and DateTime.now in a single call.)
    s.summary = s.description # More details later??
    s.email = "jtrupiano@gmail.com"
    s.homepage = "http://github.com/jtrupiano/timecop"
    s.authors = ["John Trupiano"]
    s.files =  FileList["[A-Z]*", "{bin,lib,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# Override the test task and instruct them how to actually run the tests.
Rake.application.send(:eval, "@tasks.delete('test')")
desc "Does not execute tests.  Manually run shell script ./run_tests.sh to execute tests."
task :test do
  puts <<-MSG
    In order to run the test suite, run: cd test && ./run_tests.sh
    The tests need to be run with different libraries loaded, which rules out using Rake
    to automate them.
  MSG
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  config = YAML.load(File.read('VERSION.yml'))
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "timecop #{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Rubyforge documentation task
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "release gem and documentation to rubyforge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
          File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/johntrupiano/timecop"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

task :default => :test