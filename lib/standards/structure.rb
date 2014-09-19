require 'standards/standard'

module Standards
  class Structure
    attr_reader :standards, :hierarchy

    def initialize(standards=[])
      @standards = []
      standards.each { |standard| add_standard standard }
      @hierarchy = Hierarchy.new id: 1, parent_id: nil, name: 'root'
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

    def add_hierarchy(to_add)
      parent = hierarchy.find { |h| h.id == to_add.parent_id }
      # TODO: Blow up if there is no parent?
      parent.add(to_add)
      to_add
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
