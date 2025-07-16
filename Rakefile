require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

desc 'Run all tests'
task test: :spec

desc 'Run RuboCop and tests'
task ci: %i[rubocop spec]

desc 'Generate documentation'
task docs: :yard

desc 'Clean up generated files'
task :clean do
  FileUtils.rm_rf('doc')
  FileUtils.rm_rf('coverage')
  FileUtils.rm_rf('pkg')
end

desc 'Setup development environment'
task :setup do
  puts 'Installing dependencies...'
  system('bundle install')
  puts 'Setup complete!'
end

desc 'Run examples'
task :examples do
  puts 'Running basic usage example...'
  system('ruby examples/basic_usage.rb')
end

task default: :ci
