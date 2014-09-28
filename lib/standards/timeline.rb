require 'time'

module Standards
  module Timeline
    class Event
      def self.from_json(json)
        data = Hash[
          json.fetch(:data).map { |k, v| [k.intern, v] }
        ]

        new scope: json.fetch(:scope).intern,
            type:  json.fetch(:type).intern,
            time:  Time.parse(json.fetch(:time)),
            data:  data
      end

      # TODO: rename time -> timestamp
      attr_accessor :scope, :type, :time, :data

      def initialize(attributes)
        attributes.each do |attribute, value|
          __send__ "#{attribute}=", value
        end
      end

      def as_json
        {scope: scope, type: type, time: time.to_s, data: data}
      end

      def ==(other)
        return false unless self.class === other
        as_json == other.as_json
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
      when :hierarchy
        case event.type
        when :add
          structure.add_hierarchy Hierarchy.new(event.data)
        else
          raise "Unknown type #{event.type.inspect} for scope #{event.scope.inspect}"
        end
      else
        raise "Unknown scope #{event.scope.inspect}"
      end
    end
  end
end
