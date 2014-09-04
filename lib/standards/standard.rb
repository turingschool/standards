module Standards
  class Standard
    attr_accessor :id, :standard, :tags

    # should persister blow up if you try to persist one that
    # does not have an id or a standard?
    def initialize(attributes={})
      self.id       = attributes.fetch :id,       nil
      self.standard = attributes.fetch :standard, ""
      self.tags     = attributes.fetch :tags,     []
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {id: id, standard: standard, tags: tags}
    end

    def ==(other)
      return false unless Standard === other
      to_hash == other.to_hash
    end
  end
end
