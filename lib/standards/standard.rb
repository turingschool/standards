module Standards
  class Standard
    attr_accessor :id, :standard, :tags

    # should persister blow up if you try to persist one that
    # does not have an id or a standard?
    def initialize(attributes={})
      attributes    = attributes.dup
      self.id       = attributes.delete(:id)       || nil
      self.standard = attributes.delete(:standard) || ""
      self.tags     = attributes.delete(:tags)     || []
      raise ArgumentError, "Unexpected attributes: #{attributes.inspect}" if attributes.any?
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
