require 'spec_helper'

module Standards
  def indentation(n)
    '  ' * n
  end

  # b/c I'm expecting the binary to get deleted,
  # and I want an example to show of how to use the library
  RSpec.describe 'Acceptance Spec', acceptance: true do
    it 'can all be used together' do
      # pending 'only partially implemented'

      # =====  The file we'll store our results in  =====
      timeline_filename = File.expand_path '../acceptance_spec_timeline.json', __FILE__
      File.delete timeline_filename if File.exist? timeline_filename


      # =====  The relevant data structures  =====
      timeline  = []
      structure = Structure.new


      # =====  Add some standards. We add to hierarchy so that they get their ids set, then create add events for the timeline  =====
      standard_enum_each1 = structure.add_standard standard: 'Student knows they need to define each',
                                                   tags:     ['enumerable', 'each']
      standard_enum_each2 = structure.add_standard standard: 'Student knows it takes a block and calls it for each item in the collection',
                                                   tags:     ['enumerable', 'each']

      standard_enum_find1 = structure.add_standard standard: 'Student knows it comes from Enumerable',
                                                   tags:     ['enumerable', 'find']
      standard_enum_find2 = structure.add_standard standard: 'Student knows it takes a block and returns the first element that the block returns true for',
                                                   tags:     ['enumerable', 'find']

      standard_ary_each1  = structure.add_standard standard: 'Student knows it is the iterator to use for side effects',
                                                   tags: ['array', 'each']
      standard_ary_each2  = structure.add_standard standard: 'Student knows it returns the array',
                                                   tags: ['array', 'each']

      expect(structure.select_standards(&Filter.new(tags: ['enumerable']))              ).to eq [standard_enum_each1, standard_enum_each2, standard_enum_find1, standard_enum_find2]
      expect(structure.select_standards(&Filter.new(tags: ['find']))                    ).to eq [standard_enum_find1, standard_enum_find2]
      expect(structure.select_standards(&Filter.new(tags: ['each']))                    ).to eq [standard_enum_each1, standard_enum_each2, standard_ary_each1, standard_ary_each2]
      expect(structure.select_standards(&Filter.new(tags: ['enumerable', 'each']))      ).to eq [standard_enum_each1, standard_enum_each2]


      # =====  Add the hierarchy  =====
      hierarchy_enum      = structure.add_hierarchy name: 'Enumerable'
      hierarchy_enum_each = structure.add_hierarchy name: 'Each', parent_id: hierarchy_enum.id, tags: ['enumerable', 'each']
      hierarchy_enum_find = structure.add_hierarchy name: 'Find', parent_id: hierarchy_enum.id, tags: ['enumerable', 'find']
      hierarchy_ary       = structure.add_hierarchy name: 'Array'
      hierarchy_ary_each  = structure.add_hierarchy name: 'Each', parent_id: hierarchy_ary.id,  tags: ['array', 'each']


      # =====  Build a view of standards from the hierarchy  =====
      seen = ""
      structure.each_hierarchy do |hierarchy, ancestry, &recurser|
        # The hierarchy
        inspected = indentation(ancestry.size-1) << hierarchy.name << "\n"

        # Its standards
        structure.select_standards(&hierarchy.standards_filter)
                 .each { |standard| inspected << indentation(ancestry.size) << standard.standard << "\n" }

        seen << inspected

        # Must choose to recurse, or children won't be traversed
        recurser.call
      end

      expect(seen).to eq <<-INSPECTED.gsub(/^        /, '')
        Enumerable
          Each
            Student knows they need to define each
            Student knows it takes a block and calls it for each item in the collection
          Find
            Student knows it comes from Enumerable
            Student knows it takes a block and returns the first element that the block returns true for
        Array
          Each
            Student knows it is the iterator to use for side effects
            Student knows it returns the array
      INSPECTED


      # =====  Add the standards creation to the timeline  =====
      [standard_enum_each1, standard_enum_each2, standard_enum_find1, standard_enum_find2, standard_ary_each1, standard_ary_each2].each do |standard|
        event = Timeline::Event.new(scope: :standard,
                                    type:  :add,
                                    time:  Time.now,
                                    data:  standard.to_hash)
        timeline << event
      end


      # =====  Add the hierarchies creation to the timeline  =====
      [hierarchy_enum, hierarchy_enum_each, hierarchy_enum_find, hierarchy_ary, hierarchy_ary_each].each do |hierarchy|
        event = Timeline::Event.new(scope: :hierarchy,
                                    type:  :add,
                                    time:  Time.now,
                                    data:  hierarchy.to_hash)
        timeline << event
      end


      # =====  Persist the timeline  =====
      Persistence.dump timeline_filename, timeline


      # =====  Load the timeline back out and rebuild the structure from it  =====
      new_timeline, new_structure = Persistence.load timeline_filename

      expect(new_timeline).to eq timeline
      expect(new_structure).to eq structure
    end
  end
end
