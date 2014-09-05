require 'standards/filter'

module Standards
  module ParseSelect
    def self.call(argv)
      filter_options = {tags: []}

      argv.each do |arg|
        unless arg.include? ':'
          raise SyntaxError, %'Selections must be key:value pairs, but there is is no ":" in #{arg.inspect}'
        end

        attribute, value = arg.split(":")
        case attribute
        when 'tag' then filter_options[:tags] << value
        else
          raise ArgumentError, "Unknown attribute: #{attribute}"
        end
      end

      Filter.new filter_options
    end
  end
end
