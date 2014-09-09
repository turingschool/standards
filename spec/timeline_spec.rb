require 'spec_helper'

module Standards
  class Timeline
    class Event
      attr_accessor :scope, :type, :id, :time, :data

      def initialize(attributes)
        attributes.each do |attribute, value|
          __send__ "#{attribute}=", value
        end
      end
    end

    attr_accessor :structure, :events
    def initialize(structure, events)
      @structure = structure
      @events    = events
      apply_events(structure, events)
    end

    private

    def apply_events(structure, events)
      events.each do |event|
        apply_event structure, event
      end
    end

    def apply_event(structure, event)
      case event.scope
      when :standard
        case event.type
        when :add
          structure.add_standard event.data
        else
          raise "Unknown type #{event.type.inspect} for for scope #{event.scope.inspect}"
        end
      else
        raise "Unknown scope #{scope.inspect}"
      end
    end
  end
end


describe 'Standards::Timeline' do
  Standard  = Standards::Standard
  Structure = Standards::Structure

  def timeline(*events)
    Standards::Timeline.new(Structure.new([]), events)
  end

  def event(attributes)
    Standards::Timeline::Event.new(attributes)
  end

  describe 'accessing the structure at a time in the past'
  describe 'accessing the history of a standard'

  describe 'loading' do
    it 'builds up the structure from the events' do
      tl = timeline event(scope: :standard,
                          type:  :add,
                          id:    1,
                          time:  Time.now,
                          data:  {standard: 'a', tags: ['b', 'c']}),
                    event(scope: :standard,
                          type:  :add,
                          id:    2,
                          time:  Time.now,
                          data:  {standard: 'A', tags: ['B', 'C']})

      expect(tl.structure).to eq Structure.new([
        Standard.new(id: 1, standard: 'a', tags: ['b', 'c']),
        Standard.new(id: 2, standard: 'A', tags: ['B', 'C']),
      ])
    end

    context 'translating the events' do
      context 'when scope is :standard' do
        context 'unknown type' do
          it 'blows up' do
            expect { timeline event(scope: :standard, type: :wat) }.to raise_error /type/
          end
        end

        context ':add type' do
          it 'adds the standard to the list of standards' do
            tl = timeline event scope: :standard,
                                type:  :add,
                                id:    1,
                                time:  Time.now,
                                data:  {standard: 'a', tags: ['b', 'c']}
            expect(tl.structure).to eq Structure.new([
              Standard.new(id: 1, standard: 'a', tags: ['b', 'c'])
            ])
          end

          it 'sets all the provided attributes' do
            tl = timeline event scope: :standard,
                                type:  :add,
                                id:    1,
                                time:  Time.now,
                                data:  {tags: ['b', 'c']}
            standard = tl.structure.standards.first
            expect(standard.tags).to eq ['b', 'c']
            expect(standard.standard).to eq Standard.new.standard
          end
        end
      end

      context 'when scope is not known' do
        it 'blows up' do
          expect { timeline event(scope: :wat) }.to raise_error /scope/
        end
      end
    end
  end
end
