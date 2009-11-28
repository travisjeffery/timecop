require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

gem 'jeweler', '~> 1.3.0'

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
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
    rubyforge.remote_doc_path = "timecop"
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
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.title = "timecop #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('History.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test