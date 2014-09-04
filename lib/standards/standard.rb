module Standards
  class Standard
    attr_accessor :id, :standard, :tags
    def initialize(attributes)
      self.id       = attributes.fetch :id
      self.standard = attributes.fetch :standard
      self.tags     = attributes.fetch :tags
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {id: id, standard: standard, tags: tags}
    end
  end
end
