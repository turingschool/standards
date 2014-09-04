# configuration
$LOAD_PATH.unshift '../../../lib'
require 'standards/binary'
require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

filename = Standards::Binary::STANDARD_DATA_FILENAME

# step definitions
Given 'I have not previously defined standards' do
  Haiti::CommandLineHelpers.in_proving_grounds do
    Standards::Persistence.delete(filename)
  end
end

Then 'stdout is the JSON:' do |json|
  expected = JSON.parse(json)
  actual   = JSON.parse(@last_executed.stdout)
  expect(actual).to eq expected
end

Then /^I have a standard "(.*?)", with tags (\[.*?\])?$/ do |expected_standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    expected_tags     = eval(tagstring)
    structure = Standards::Persistence.load(filename)
    @current_standard = structure.standards.find do |s|
      s.standard == expected_standard && s.tags == expected_tags
    end
  end
  expect(@current_standard).to be
end

Given /^I have previously added "(.*)", with tags (\[.*?\])?$/ do |standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    Standards::Persistence.dump filename,
                                Standards::Structure.new([
                                  Standards::Standard.new(standard: standard,
                                                          tags:     eval(tagstring),
                                                          id:       1)
                                ])
  end
end
