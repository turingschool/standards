module Standards
  class Filter
    def initialize(options)
      self.options = options
    end

    def allow?(standard)
      tag_filters.all? do |tag_filter|
        standard.tags.any? { |tag| tag_filter === tag }
      end
    end

    def to_proc
      method(:allow?).to_proc
    end

    private

    attr_accessor :options

    def tag_filters
      options[:tags]
    end
  end
end
