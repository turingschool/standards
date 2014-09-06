require 'standards'
require 'standards/binary/parse_select'

module Standards
  class Binary
    FILE_ENV_VARNAME           = 'STANDARDS_FILEPATH'
    SUCCESS_STATUS             = 0
    ERROR_STATUS               = 1
    UnknownCommand             = Class.new StandardsError
    StandardsFilepathIsMissing = Class.new StandardsError do
      def initialize
        super "You must provide the path to a standards file to operate on\n"\
              "Either set the #{FILE_ENV_VARNAME} environment variable,\n"\
              "or pass it as an argument with -f / --file"
      end
    end


    def self.call(env, argv, stdin, stdout, stderr)
      new(env, argv, stdin, stdout, stderr).call
    end

    attr_reader :env, :argv, :stdin, :stdout, :stderr

    def initialize(env, argv, stdin, stdout, stderr)
      @argv     = argv.dup
      @stdin    = stdin
      @stdout   = stdout
      @stderr   = stderr
      @filepath = extract_filepath(env, @argv)
    end

    def extract_filepath(env, argv)
      flag_index = argv.index('--file') || argv.index('-f')
      return env[FILE_ENV_VARNAME] unless flag_index
      flag, filepath = argv.slice!(flag_index, 2)
      filepath
    end

    def filepath
      @filepath || raise(StandardsFilepathIsMissing)
    end

    def structure
      @structure ||= Persistence.load filepath
    end

    def call
      command, *args = argv

      case command
      when 'add'
        standard, *tags = args
        standard = structure.add_standard standard: standard, tags: tags
        Persistence.dump filepath, structure
        stdout.puts standard.to_json
      when 'select'
        filter = ParseSelect.call(args)
        selected_standards = structure.select_standards &filter
        stdout.puts selected_standards.map(&:to_hash).to_json
      when 'webpage'
        stdout.puts GenerateBasicSite.call(structure)
      when 'help'
        stdout.puts self.class.help_screen
      else
        raise UnknownCommand, "Don't know the command #{command.inspect}"
      end
      SUCCESS_STATUS
    rescue Exception => e
      stderr.puts e.class
      stderr.puts '-' * e.class.to_s.size
      stderr.puts
      stderr.puts e.message
      ERROR_STATUS
    end

    def self.help_screen
      <<-HELP.tap { |help| help.gsub! /^#{help[/\A\s*/]}/, "" }
      Usage: standards COMMAND [args]

        https://github.com/turingschool/standards

      Environment variables
        #{FILE_ENV_VARNAME}                      # Location of standards file to read from and write to

      Global flags
        -f, --file FILEPATH                     # Location of standards file to read from and write to

      Commands:
        add "SWBAT do something" [sometag, ...] # Add a new standard with given tags
        select [tag:tagname, ...]               # Display the standards that match the filter
        webpage                                 # Prints HTML representation of data
        help                                    # This screen
      HELP
    end
  end
end
