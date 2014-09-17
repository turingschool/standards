$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'standards'

timeline, structure = Standards::Persistence.load 'standards.json'
html                = Standards::GenerateBasicSite.call structure
app                 = lambda do |env|
  [200, {'Content-Type' => 'text/html'}, [html]]
end
run app
