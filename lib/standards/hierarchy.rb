module Standards
  class Hierarchy
    attr_reader :name, :tags, :subhierarchies

    def initialize(name, tags=[])
      @name           = name
      @tags           = tags
      @subhierarchies = []
    end

    def root?
      !name
    end

    def size
      @subhierarchies.size
    end

    def add(hierarchy)
      subhierarchies << hierarchy
      self
    end

    def depth_first(&block)
      _depth_first([], block)
    end

    def standards_filter
      Standards::Filter.new(tags: tags)
    end

    def inspect
      "#<Standards::Hierarchy #{name}>"
    end

    protected

    def _depth_first(ancestry, block)
      block.call self, ancestry do
        subhierarchies.each do |subhierarchy|
          subhierarchy._depth_first [self, *ancestry], block
        end
      end
    end
  end
end