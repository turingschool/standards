require 'json'
require 'standards/structure'

module Standards
  module Persistence
    def self.load(filename)
      initialize_data_file filename
      body     = File.read filename
      timeline = JSON::Ext::Parser.new(body, symbolize_names: true)
                                  .parse
                                  .map &Timeline::Event.method(:from_json)
      structure = Structure.new
      Timeline.apply_events structure, timeline
      return timeline, structure
    end

    def self.dump(filename, timeline)
      ensure_path File.dirname(filename)
      File.write filename, timeline.map(&:as_json).to_json
    end

    def self.delete(filename)
      File.delete filename if File.exist? filename
    end

    private

    def self.initialize_data_file(filename)
      return if File.exist? filename
      dump filename, []
    end

    def self.ensure_path(path)
      return if Dir.exist? path
      ensure_path File.dirname path
      Dir.mkdir path
    end
  end
end
