task :fix_loadpath do
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
end

task load_lib: :fix_loadpath do
  require 'standards'
end

desc 'Run all tests'
task default: 'test:all'

namespace :test do
  desc 'Run unit tests'
  task(:spec) { sh 'rspec' }

  desc 'Run cucumber tests'
  task(:cuke) { sh 'cucumber' }

  desc 'Test the generated webpage'
  task(:site) { sh 'rspec --tag js' }

  desc 'Run all tests'
  task all: %w[test:spec test:cuke test:site]
end

def self.serve(app)
  # notify user where to find the output, serve the app
  require 'rack'
  puts "\e[32mhttp://localhost:1235/\e[0m"
  puts "\e[31mControl-C to kill server \e[0m"
  puts
  Rack::Server.start app: app, Port: 1235, server: 'webrick'
end


desc 'Serve the app (real data)'
task(:server) { sh 'rackup' }

namespace :server do
  desc 'Reloadable app with dummy data for playing with css/js'
  task play: :load_lib do
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

    serve app
  end
end
