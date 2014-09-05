task :fix_loadpath do
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
end

task load_lib: :fix_loadpath do
  require 'standards'
end

desc 'Runs all tests'
task default: %w[test:spec test:cuke test:site]

namespace :test do
  desc 'run unit tests'
  task(:spec) { sh 'rspec' }

  desc 'run cucumber tests'
  task(:cuke) { sh 'cucumber' }

  desc 'test the generated webpage'
  task(:site) { sh 'rspec --tag js' }
end


desc 'serve the html with dummy data (useful for seeing css/js)'
task serve: :load_lib do
  # dummy structure
  structure = Standards::Structure.new
  structure.add_standard standard: 'SWBAT explain and demonstrate the TDD workflow.',      tags: ['testing', 'tdd']
  structure.add_standard standard: 'SWBAT write assertions using assert_true and assert.', tags: ['testing', 'minitest', 'assertions']
  structure.add_standard standard: 'SWBAT read and fix error messages.',                   tags: ['testing', 'errors']

  # reloads code, regens html, displays and serves
  app = lambda do |env|
    Standards.__send__ :remove_const, :GenerateBasicSite
    load 'standards/generate_basic_site.rb'
    html = Standards::GenerateBasicSite.call structure
    time = Time.now.strftime '%l:%M %p'
    $stderr.puts "\e[2J\e[1;1H#{time}\n\n#{html}"
    [200, {'Content-Type' => 'text/html'}, [html]]
  end

  # notify user where to find the output, serve the app
  require 'rack'
  puts "\e[32mhttp://localhost:1235/\e[0m"
  puts "\e[31mControl-C to kill server \e[0m"
  puts
  Rack::Server.start app: app, Port: 1235, server: 'webrick'
end
