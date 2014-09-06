# configuration
$LOAD_PATH.unshift '../../../lib'
require 'standards/binary'
require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

filename = File.join Haiti.config.proving_grounds_dir, 'standards.json'
ENV['STANDARDS_FILEPATH'] = filename
s = Standards

# Stuff that should maybe be in Haiti

Then 'stdout is the JSON:' do |json|
  expected = JSON.parse(json)
  actual   = JSON.parse(@last_executed.stdout)
  expect(actual).to eq expected
end

Then "stdout is the JSON '$json'" do |json|
  expected = JSON.parse(json)
  actual   = JSON.parse(@last_executed.stdout)
  expect(actual).to eq expected
end

Given 'there is no file "$filename"' do |filename|
  Haiti::CommandLineHelpers.in_proving_grounds do
    File.delete filename if File.exist? filename
  end
end

Then /^I have a standard "(.*?)", with tags (\[.*?\])?$/ do |expected_standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    expected_tags     = eval(tagstring)
    structure = s::Persistence.load(filename)
    @current_standard = structure.standards.find do |s|
      s.standard == expected_standard && s.tags == expected_tags
    end
  end
  expect(@current_standard).to be
end

# Standards
Given 'I have not previously defined standards' do
  Haiti::CommandLineHelpers.in_proving_grounds do
    s::Persistence.delete(filename)
  end
end
Given /^I have previously added "(.*)", with tags (\[.*?\])?$/ do |standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    s::Persistence.dump filename,
                        s::Structure.new([
                          s::Standard.new(standard: standard,
                                          tags:     eval(tagstring),
                                          id:       1)
                          ])
  end
end
