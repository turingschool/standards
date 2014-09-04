require 'standards'

module Standards
  module Binary
    STANDARD_DATA_FILENAME = "standards.json"

    def self.call(argv, stdin, stdout, stderr)
      structure = Persistence.load STANDARD_DATA_FILENAME

      if argv.first == 'add'
        standard = Standard.new standard: argv[1],
                                tags:     argv[2..-1].reject { |arg| arg == '--tag' },
                                id:       1
        structure.standards << standard
        Persistence.dump STANDARD_DATA_FILENAME, structure
        stdout.puts standard.to_json
      elsif argv.first == 'select'
        # filter based on argv ('tag:tag1')
        search_info        = argv.last
        search_term, value = search_info.split(":")

        selected_standards = structure.standards.select do |standard|
          standard.tags.include?(value)
        end

        # print it to stdout
        stdout.puts selected_standards.map(&:as_json).to_json
      else
        raise "wat? #{argv.inspect}"
      end
    end
  end
end
