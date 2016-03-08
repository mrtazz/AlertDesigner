#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => ["test:unit", "test:integration"]

namespace :test do

  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.test_files = FileList['test/unit/test*.rb']
    t.verbose = true
  end

  Rake::TestTask.new(:integration) do |t|
    t.libs << "test"
    t.test_files = FileList['test/integration/test*.rb']
    t.verbose = true
  end

end

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :ci => ["test:unit", "test:integration", 'coveralls:push']
