module Standards
  class Standard
    attr_accessor :id, :standard, :tags
    def initialize(attributes)
      self.id       = attributes.fetch :id
      self.standard = attributes.fetch :standard
      self.tags     = attributes.fetch :tags
    end

    def to_json
      as_json.to_json
    end

    def as_json
      {id: id, standard: standard, tags: tags}
    end
  end
end
