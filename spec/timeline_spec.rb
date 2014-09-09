require 'spec_helper'

# To change:
#   persistence uses timeline events

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
                              id:    1,
                              time:  Time.now,
                              data:  {standard: 'a', tags: ['b', 'c']}),
                        event(scope: :standard,
                              type:  :add,
                              id:    2,
                              time:  Time.now,
                              data:  {standard: 'A', tags: ['B', 'C']})

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
                                    id:    1,
                                    time:  Time.now,
                                    data:  {standard: 'a', tags: ['b', 'c']}
            expect(structure).to eq Structure.new([
              Standard.new(id: 1, standard: 'a', tags: ['b', 'c'])
            ])
          end

          it 'sets all the provided attributes' do
            structure = build event scope: :standard,
                                    type:  :add,
                                    id:    1,
                                    time:  Time.now,
                                    data:  {tags: ['b', 'c']}
            standard = structure.standards.first
            expect(standard.tags).to eq ['b', 'c']
            expect(standard.standard).to eq Standard.new.standard
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
