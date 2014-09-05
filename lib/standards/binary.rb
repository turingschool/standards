require 'standards'
require 'standards/binary/parse_select'

module Standards
  module Binary
    STANDARD_DATA_FILENAME = "standards.json"

    def self.call(argv, stdin, stdout, stderr)
      structure = Persistence.load STANDARD_DATA_FILENAME

      if argv.first == 'add'
        standard = structure.add_standard standard: argv[1],
                                          tags:     argv[2..-1].reject { |arg| arg == '--tag' },
                                          id:       1

        Persistence.dump STANDARD_DATA_FILENAME, structure
        stdout.puts standard.to_json
      elsif argv.first == 'select'
        filter             = ParseSelect.call argv.drop(1)
        selected_standards = structure.select_standards &filter
        stdout.puts selected_standards.map(&:to_hash).to_json
      else
        raise "wat? #{argv.inspect}"
      end
    end
  end
end
