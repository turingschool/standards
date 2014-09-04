require 'json'
require 'standards/structure'

module Standards
  module Persistence
    def self.load(filename)
      initialize_data_file filename
      raw_structure = File.read filename
      Structure.from_hash JSON.parse(raw_structure)
    end

    def self.dump(filename, structure)
      File.write filename, structure.to_json
    end

    def self.delete(filename)
      File.delete filename if File.exist? filename
    end

    private

    def self.initialize_data_file(filename)
      return if File.exist? filename
      File.write filename, Structure.new([]).to_json
    end
  end
end
