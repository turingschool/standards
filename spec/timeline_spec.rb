require 'spec_helper'

# go back to a more oo structure in a bit here

describe 'Standards::Timeline' do
  Standard  = Standards::Standard
  Structure = Standards::Structure

  def build(*events)
    Standards::Timeline.apply_events(Structure.new([]), events)
  end

  def event(attributes)
    Standards::Timeline::Event.new(attributes)
  end

  describe 'accessing the structure at a time in the past'
  describe 'accessing the history of a standard'

  describe 'loading' do
    it 'builds up the structure from the events' do
      structure = build event(scope: :standard,
                              type:  :add,
                              time:  Time.now,
                              data:  {standard: 'a', id: 1, tags: ['b', 'c']}),
                        event(scope: :standard,
                              type:  :add,
                              time:  Time.now,
                              data:  {standard: 'A', id: 2, tags: ['B', 'C']})

      expect(structure).to eq Structure.new([
        Standard.new(id: 1, standard: 'a', tags: ['b', 'c']),
        Standard.new(id: 2, standard: 'A', tags: ['B', 'C']),
      ])
    end

    context 'translating the events' do
      context 'when scope is :standard' do
        context 'unknown type' do
          it 'blows up' do
            expect { build event(scope: :standard, type: :wat) }.to raise_error /type/
          end
        end

        context ':add type' do
          it 'adds the standard to the list of standards' do
            structure = build event scope: :standard,
                                    type:  :add,
                                    time:  Time.now,
                                    data:  {standard: 'a', id: 1, tags: ['b', 'c']}
            expect(structure).to eq Structure.new([
              Standard.new(id: 1, standard: 'a', tags: ['b', 'c'])
            ])
          end
        end
      end

      context 'when scope is :hierarchy' do
        def self.next_id
          @hierarchy_id ||= 1 # let the root have id 1
          @hierarchy_id += 1
        end

        def event(overridden_attributes)
          id              = self.class.next_id
          data            = {name: "zomg", id: id, tags: ['a', 'b'], parent_id: 1} # parent_id of 1 implies its under root
          overridden_data = overridden_attributes.delete(:data) || {}
          attributes      = { scope: :hierarchy,
                              type:  :add,
                              time:  Time.now,
                              data:  data.merge(overridden_data) }
          super attributes.merge overridden_attributes
        end

        context 'unknown type' do
          it 'blows up' do
            expect { build event(scope: :hierarchy, type: :wat) }.to raise_error /type/
          end
        end

        context 'add type' do
          it 'sets all the provided attributes' do
            structure = build event type: :add, data: {name: 'mah namez', tags: ['x', 'y']}
            hierarchy = structure.root_hierarchy.subhierarchies.first
            expect(hierarchy.name).to eq 'mah namez'
            expect(hierarchy.tags).to eq ['x','y']
          end

          it 'adds the hierarchy to appropriate place within the hierarchies' do
            structure = build(
              (event1  = event type: :add, data: {name: 'a'}),
              (event11 = event type: :add, data: {name: 'b', parent_id: event1.data[:id]}),
              (event2  = event type: :add, data: {name: 'c'}),
              (event12 = event type: :add, data: {name: 'd', parent_id: event1.data[:id]}),
            )
            root = structure.root_hierarchy

            seen = []
            structure.root_hierarchy.depth_first { |hierarchy, ancestry, &recurse|
              seen << [hierarchy.name, ancestry.map(&:name)]
              recurse.call
            }
            expect(seen).to eq [['root', []],
                                ['a',    ['root']],
                                ['b',    ['a', 'root']],
                                ['d',    ['a', 'root']],
                                ['c',    ['root']]]
          end
        end
      end

      context 'when scope is not known' do
        it 'blows up' do
          expect { build event(scope: :wat) }.to raise_error /scope/
        end
      end
    end
  end
end
