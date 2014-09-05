require 'standards'
require 'standards/binary/parse_select'

module Standards
  module Binary
    STANDARD_DATA_FILENAME = "standards.json"

    def self.call(argv, stdin, stdout, stderr)
      structure = Persistence.load STANDARD_DATA_FILENAME
      command, *args = argv

      case command
      when 'add'
        standard, *tags = args
        standard = structure.add_standard standard: standard, tags: tags, id: 1
        Persistence.dump STANDARD_DATA_FILENAME, structure
        stdout.puts standard.to_json
      when 'select'
        filter = ParseSelect.call(args)
        selected_standards = structure.select_standards &filter
        stdout.puts selected_standards.map(&:to_hash).to_json
      when 'generate'
        stdout.puts GenerateBasicSite.call(structure)
      else
        raise "wat? #{argv.inspect}"
      end
    end
  end
end
