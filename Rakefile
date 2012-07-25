require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

$LOAD_PATH.unshift("lib")

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

require 'rdoc/task'
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

desc 'Default: run tests'
task :default => [:test]
