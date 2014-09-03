# configuration
$LOAD_PATH.unshift '../../../lib'
require 'standards'
require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

# step definitions
Given 'I have not previously defined standards' do
  Haiti::CommandLineHelpers.in_proving_grounds do
    filename = Standards::Binary::STANDARD_DATA_FILENAME
    File.delete filename if File.exist? filename
  end
end

Then 'stdout is the JSON:' do |json|
  expected = JSON.parse(json)
  actual   = JSON.parse(@last_executed.stdout)
  expect(actual).to eq expected
end

Given /^I have a standard "(.*?)"(?:, with tags (\[.*?\]))?$/ do |expected_standard, tagstring|
  expected_tags     = eval(tagstring||"[]")
  raw_json          = Haiti::CommandLineHelpers.read_file 'standards.json'
  standards         = JSON.parse(raw_json)['standards']
  @current_standard = standards.find do |s|
    s['standard'] == expected_standard && s['tags'] == expected_tags
  end
  expect(@current_standard).to be
end
