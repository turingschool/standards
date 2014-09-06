# configuration

$LOAD_PATH.unshift '../../../lib'
require 'standards/binary'
require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

standards_filepath = File.join Haiti.config.proving_grounds_dir, 'standards.json'
s = Standards

Before {
  ENV['STANDARDS_FILEPATH'] = standards_filepath
}

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

Then 'I do not see the file "$filename"' do |filename|
  Haiti::CommandLineHelpers.in_proving_grounds do
    file_exists = Haiti::CommandLineHelpers.in_proving_grounds { File.exist? filename }
    expect(file_exists).to eq false
  end
end

Then /^I have a standard "(.*?)", with tags (\[.*?\])?$/ do |expected_standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    expected_tags     = eval(tagstring)
    structure = s::Persistence.load(standards_filepath)
    @current_standard = structure.standards.find do |s|
      s.standard == expected_standard && s.tags == expected_tags
    end
  end
  expect(@current_standard).to be
end

Given 'the environment variable "$name" is not set' do |name|
  # would be nice if we could hook into an after block to reset this
  # rather than having to set our env vars before each feature
  # idk if that's a thing or not, maybe research it later
  ENV[name] = nil
end


# Standards

Given 'I have not previously defined standards' do
  Haiti::CommandLineHelpers.in_proving_grounds do
    s::Persistence.delete(standards_filepath)
  end
end

Given /^I have previously added "(.*)", with tags (\[.*?\])?$/ do |standard, tagstring|
  Haiti::CommandLineHelpers.in_proving_grounds do
    s::Persistence.dump standards_filepath,
                        s::Structure.new([
                          s::Standard.new(standard: standard,
                                          tags:     eval(tagstring),
                                          id:       1)
                          ])
  end
end
