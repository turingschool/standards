require 'standards/standard'

module Standards
  class Structure
    attr_reader :standards, :hierarchy

    # TODO: Should we disallow this sort of initialization with pre-populated data?
    # TODO: reanme @hierarchy to @root_hierarchy, but still expose root when method `hierarchy` is called
    def initialize(standards=[])
      @standards = []
      standards.each { |standard| add_standard standard }
      @hierarchy = Hierarchy.new id: 1, parent_id: nil, name: 'root'
      @hierarchy_size = 1
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {standards: standards.map(&:to_hash)}
    end

    # TODO: Do I really want to accept attributes instead of standards?
    def add_standard(standard_attributes)
      new_standard = standard_attributes
      new_standard = Standard.new(standard_attributes) unless Standard === standard_attributes

      new_standard.id ||= next_standard_id

      if overlap = standards.find { |old_standard| old_standard.id == new_standard.id }
        raise ArgumentError, "You provided the id #{new_standard.id.inspect}, which overlaps with #{overlap.inspect}"
      end

      standards << new_standard
      new_standard
    end


    # TODO: Disliking that it will accept a Hierarchy and also a hash
    def add_hierarchy(hierarchy_attributes)
      @hierarchy_size += 1

      if Hierarchy === hierarchy_attributes
        to_add = hierarchy_attributes
      else
        hierarchy_attributes[:id]        ||= @hierarchy_size
        hierarchy_attributes[:parent_id] ||= hierarchy.id
        to_add = Hierarchy.new hierarchy_attributes
      end

      parent = hierarchy.find { |h| h.id == to_add.parent_id }
      # TODO: Blow up if there is no parent?
      parent.add(to_add)
      to_add
    end

    def each_hierarchy(&block)
      @hierarchy.depth_first do |current, ancestry, &recurser|
        if current == @hierarchy
          recurser.call
        else
          block.call(current, ancestry, &recurser)
        end
      end
    end

    def ==(other)
      return false unless self.class === other
      standards == other.standards
    end

    def select_standards(&filter)
      standards.select(&filter)
    end

    private

    def next_standard_id
      (standards.map(&:id).max || 0).next
    end
  end
end
