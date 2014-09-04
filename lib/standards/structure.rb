require 'standards/standard'

module Standards
  class Structure
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
