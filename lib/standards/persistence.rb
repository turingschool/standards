require 'json'
require 'standards/structure'

module Standards
  module Persistence
    def self.load(filename)
      initialize_data_file filename
      structure_from_json File.read filename
    end

    def self.dump(filename, structure)
      File.write filename, structure.to_json
    end

    def self.delete(filename)
      File.delete filename if File.exist? filename
    end

    private

    def self.structure_from_json(structure_json)
      Structure.new \
        JSON::Ext::Parser.new(structure_json, symbolize_names: true)
                         .parse
                         .fetch(:standards)
                         .map &Standard.method(:new)
    end


    def self.initialize_data_file(filename)
      return if File.exist? filename
      File.write filename, Structure.new([]).to_json
    end
  end
end
