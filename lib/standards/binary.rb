require 'standards'
require 'standards/binary/parse_select'

module Standards
  module Binary
    SUCCESS_STATUS         = 0
    ERROR_STATUS           = 1
    UnknownCommand         = Class.new StandardsError
    STANDARD_DATA_FILENAME = "standards.json"

    def self.call(argv, stdin, stdout, stderr)
      argv      = argv.dup
      filename  = extract_filename(argv) || STANDARD_DATA_FILENAME
      structure = Persistence.load filename
      command, *args = argv

      case command
      when 'add'
        standard, *tags = args
        standard = structure.add_standard standard: standard, tags: tags
        Persistence.dump filename, structure
        stdout.puts standard.to_json
      when 'select'
        filter = ParseSelect.call(args)
        selected_standards = structure.select_standards &filter
        stdout.puts selected_standards.map(&:to_hash).to_json
      when 'webpage'
        stdout.puts GenerateBasicSite.call(structure)
      when 'help'
        stdout.puts help_screen
      else
        raise UnknownCommand, "Don't know the command #{command.inspect}"
      end
      SUCCESS_STATUS
    rescue Exception => e
      stderr.puts e.class
      stderr.puts e.message
      ERROR_STATUS
    end

    def self.help_screen
      <<-HELP.tap { |help| help.gsub! /^#{help[/\A\s*/]}/, "" }
      Usage: standards COMMAND [args]

        https://github.com/turingschool/standards

      Global flags
        -f, --file FILENAME                     # Location of standards file to read from and write to

      Commands:
        add "SWBAT do something" [sometag, ...] # Add a new standard with given tags
        select [tag:tagname, ...]               # Display the standards that match the filter
        webpage                                 # Prints HTML representation of data
        help                                    # This screen
      HELP
    end

    def self.extract_filename(argv)
      flag_index = argv.index('--file') || argv.index('-f')
      return nil unless flag_index
      flag, filename = argv.slice!(flag_index, 2)
      filename
    end
  end
end
