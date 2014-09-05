require 'standards/binary'

RSpec.configure do |config|
  config.include Standards
  config.filter_run_excluding js: true
end
