# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.description = 'Run tests'
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
end

desc 'Run linter'
RuboCop::RakeTask.new

desc 'Generate documentation'
YARD::Rake::YardocTask.new

task default: %i[test rubocop]
