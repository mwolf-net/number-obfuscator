require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/tc_*.rb']
  t.verbose = true
end

desc "Run tests"
task :default => :test

