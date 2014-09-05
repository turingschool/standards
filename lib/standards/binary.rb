require 'standards'
require 'standards/binary/parse_select'

module Standards
  module Binary
    SUCCESS_STATUS         = 0
    ERROR_STATUS           = 1
    UnknownCommand         = Class.new StandardsError
    STANDARD_DATA_FILENAME = "standards.json"

    def self.call(argv, stdin, stdout, stderr)
      structure = Persistence.load STANDARD_DATA_FILENAME
      command, *args = argv

      case command
      when 'add'
        standard, *tags = args
        standard = structure.add_standard standard: standard, tags: tags
        Persistence.dump STANDARD_DATA_FILENAME, structure
        stdout.puts standard.to_json
      when 'select'
        filter = ParseSelect.call(args)
        selected_standards = structure.select_standards &filter
        stdout.puts selected_standards.map(&:to_hash).to_json
      when 'generate'
        stdout.puts GenerateBasicSite.call(structure)
      else
        raise UnknownCommand, "Don't know the command #{command.inspect}"
      end
      SUCCESS_STATUS
    rescue Exception => e
      stderr.puts e.class
      stderr.puts e.message
      ERROR_STATUS
    end
  end
end
