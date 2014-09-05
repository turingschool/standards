require 'spec_helper'

RSpec.describe 'GenerateBasicSite', js:true do
  def page
    @page ||= Capybara.current_session
  end

  def dirname
    @dirname ||= File.expand_path '../../proving_grounds', __FILE__
  end

  def filename
    @filename ||= File.expand_path 'standards.html', dirname
  end

  def file_url
    @file_url ||= "file://#{filename}"
  end

  before :all do
    require 'capybara/poltergeist'
    Capybara.default_driver = :poltergeist

    structure = Standards::Structure.new
    standard = structure.add_standard standard: 'SW a', tags: ['tag1', 'tag2'], id: 1
    standard = structure.add_standard standard: 'SW b', tags: ['tag2', 'tag3'], id: 2
    standard = structure.add_standard standard: 'SW c', tags: ['tag1', 'tag3'], id: 3

    html = Standards::GenerateBasicSite.call structure
    Dir.mkdir dirname unless Dir.exist? dirname
    File.write filename, html
  end

  before :each do
    page.visit file_url
  end

  it 'temp test to show its wired up right' do
    expect(page).to have_content 'omg wtf bbq'
  end

  describe 'displaying a standard' do
    it 'displays the standard, tags, and id'
  end

  describe 'showing standards' do
    it 'displays all the standards by default'
    it 'displays all tags along the top'
    it 'filters the displayed standards by which tag was clicked'
  end
end