ENV['JASMINE_CONFIG_PATH'] ||= File.expand_path('../spec//basic_site/jasmine.yml', __FILE__)

desc 'run rspec tests'
task :spec do
  sh 'rspec'
end

desc 'run cucumber tests'
task :cuke do
  sh 'cucumber'
end

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

desc 'Run specs and cukes'
task default: [:spec, :cuke, 'jasmine:ci']
