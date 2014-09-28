require 'spec_helper'
require 'fakefs/spec_helpers'

RSpec.describe 'Persistence' do
  def self.next_id
    @current_id ||= 0
    @current_id += 1
  end

  include FakeFS::SpecHelpers

  def timeline_event(attribute_overrides={})
    attributes = {scope: :standard,
                  type:  :add,
                  time:  Time.now,
                  data:  Standards::Standard.new.to_hash}
    attributes.merge! attribute_overrides
    Standards::Timeline::Event.new(attributes)
  end

  before { @timeline, @structure = Standards::Persistence.build [timeline_event.as_json, timeline_event.as_json] }
  attr_reader :timeline, :structure

  let(:filename) { "mystructure" }

  def dump(filename, timeline)
    Standards::Persistence.dump filename, timeline
  end

  def load(filename)
    Standards::Persistence.load filename
  end

  describe 'psersisting' do
    it 'can re-load what it dumps and build the structure and timeline from it' do
      dump(filename, timeline)
      loaded_timeline, loaded_structure = load(filename)
      expect(loaded_timeline).to  eq timeline
      expect(loaded_structure).to eq structure
    end
  end

  describe 'dumping' do
    it 'dumps the structure to the file in JSON format' do
      dump(filename, timeline)
      expect(JSON.load(File.read filename)).to be_a_kind_of Array
    end

    it 'overwrites the existing contents of the file' do
      File.write(filename, "content")
      dump filename, timeline
      body = File.read filename
      expect(body).to_not include "content"
      expect(body).to include '"id":'
    end

    it 'creates the path to the file if the path DNE' do
      dump '/a/b/c', timeline
      body = File.read '/a/b/c'
      expect(body).to include '"id":'
    end
  end

  describe 'loading' do
    it 'returns an empty Structure object when the file DNE' do
      expect(File.exist? filename).to eq false
      timeline, structure = load(filename)
      expect(structure).to eq Standards::Structure.new
    end
  end

  describe 'deleting' do
    def delete(filename)
      Standards::Persistence.delete filename
    end

    it 'deletes the file if it exists' do
      File.write filename, 'some body'
      delete filename
      expect(File.exist? filename).to eq false
    end

    it 'does nothing if the file DNE' do
      expect(File.exist? filename).to eq false
      expect { delete filename }.to_not raise_error
      expect(File.exist? filename).to eq false
    end
  end
end
