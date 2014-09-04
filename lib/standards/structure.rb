require 'standards/standard'

module Standards
  class Structure
    attr_accessor :standards
    def initialize(standards)
      self.standards = standards
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {standards: standards.map(&:to_hash)}
    end

    def add_standard(standard_attributes)
      Standard.new(standard_attributes)
              .tap { |s| standards << s }
    end
  end
end
