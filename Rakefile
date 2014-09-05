desc 'run unit tests'
task :spec do
  sh 'rspec'
end

desc 'run cucumber tests'
task :cuke do
  sh 'cucumber'
end

desc 'test the generated webpage'
task :test_web do
  sh 'rspec --tag js'
end

desc 'Run specs and cukes'
task default: [:spec, :cuke, :test_web]
