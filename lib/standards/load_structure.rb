# require 'standards/structure'

module Standards
  module LoadStructure
    def self.call(filename)
      initialize_data_file filename
      raw_structure = File.read filename
      Structure.from_hash JSON.parse(raw_structure)
    end

    private

    def self.initialize_data_file(filename)
      return if File.exist? filename
      File.write filename, Structure.new([]).to_json
    end
  end
end
