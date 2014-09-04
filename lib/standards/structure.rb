require 'standards/standard'

module Standards
  class Structure
    def self.from_hash(structure_hash)
      standards =
        structure_hash.fetch('standards')
                      .map { |standard_hash|
                        Standard.new id:       standard_hash.fetch('id'),
                                     standard: standard_hash.fetch('standard'),
                                     tags:     standard_hash.fetch('tags')
                      }
      Structure.new standards
    end

    attr_accessor :standards
    def initialize(standards)
      self.standards = standards
    end

    def to_json
      as_json.to_json
    end

    def as_json
      {standards: standards.map(&:as_json)}
    end

    def add_standard(standard_attributes)
      Standard.new(standard_attributes)
              .tap { |s| standards << s }
    end
  end
end
