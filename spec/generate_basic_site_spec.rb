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

  describe 'displaying a standard' do
    it 'displays the standard, tags, and id' do
      page.within '.standard:nth-child(1)' do |x|
        expect(page).to have_css '.id',               text: '1'
        expect(page).to have_css '.body',             text: 'SW a'
        expect(page).to have_css '.tag:nth-child(1)', text: 'tag1'
        expect(page).to have_css '.tag:nth-child(2)', text: 'tag2'
        expect(page).to have_css '.tags > .tag',      count: 2
      end
    end
  end

  describe 'showing standards' do
    it 'displays all the standards by default' do
      expect(page).to have_content 'SW a'
      expect(page).to have_content 'SW b'
      expect(page).to have_content 'SW c'
    end

    it 'displays all tags along the top' do
      page.within '.main-tags' do
        expect(page).to have_css '.tag', count: 3
        expect(page.text.split(/(?<=\d)/).map(&:strip).sort).to eq %w[tag1 tag2 tag3]
      end
    end

    it 'filters the displayed standards by which tag was clicked' do
      page.within('.main-tags') { page.click_on 'tag1' }
      expect(page).to     have_css '.standard .body', text: 'SW a'
      expect(page).to     have_css '.standard .body', text: 'SW c'
      expect(page).to_not have_css '.standard .body', text: 'SW b'

      page.within('.standard:nth-child(3)') { page.click_on 'tag3' }
      expect(page).to     have_css '.standard .body', text: 'SW b'
      expect(page).to     have_css '.standard .body', text: 'SW c'
      expect(page).to_not have_css '.standard .body', text: 'SW a'
    end
  end
end
