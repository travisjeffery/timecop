require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "timecop"
    s.rubyforge_project = 'johntrupiano' # if different than lowercase project name
    s.description = %q(A gem providing simple ways to temporarily override Time.now, Date.today, and DateTime.now.  It provides "time travel" capabilities, making it dead simple to test time-dependent code.)
    s.summary = s.description # More details later??
    s.email = "jtrupiano@gmail.com"
    s.homepage = "http://github.com/jtrupiano/timecop"
    s.authors = ["John Trupiano"]
    s.files =  FileList["[A-Z]*", "{bin,lib,test}/**/*"]
    #s.add_dependency 'schacon-git'
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
