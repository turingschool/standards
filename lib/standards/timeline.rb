module Standards
  module Timeline
    class Event
      attr_accessor :scope, :type, :id, :time, :data

      def initialize(attributes)
        attributes.each do |attribute, value|
          __send__ "#{attribute}=", value
        end
      end
    end

    def self.apply_events(structure, events)
      events.each { |event| apply_event structure, event }
      structure
    end

    def self.apply_event(structure, event)
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
