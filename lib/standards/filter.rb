module Standards
  class Filter
    def initialize(options)
      self.tag_filters = options.fetch :tags, []
    end

    def allow?(standard)
      tag_filters.all? do |tag_filter|
        standard.tags.any? { |tag| tag_filter === tag }
      end
    end

    def to_proc
      method(:allow?).to_proc
    end

    def ==(other)
      return false unless self.class === other
      tag_filters == other.tag_filters
    end

    protected

    attr_accessor :tag_filters
  end
end
