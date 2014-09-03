require 'json'

module Standards
  module Binary
    # { "standards": [
    #     { "id":       1,
    #       "standard": "SW know that find is a method used on collections.",
    #       "tags":     ["ruby", "enumerable"],
    #     },
    #     { "id":       2,
    #       "standard": "SW know that map is a method used on collections.",
    #       "tags":     ["ruby", "enumerable"],
    #     },
    #   ],
    # }
    STANDARD_DATA_FILENAME = "standards.json"
    def self.call(argv, stdin, stdout, stderr)
      if argv.first == 'add'
        initialize_data_file STANDARD_DATA_FILENAME
        standard = {
          'standard' => argv[1],
          'tags'     => argv[2..-1].reject { |arg| arg == '--tag' },
          'id'       => 1,
        }
        raw_structure = File.read STANDARD_DATA_FILENAME
        structure     = JSON.parse(raw_structure)
        structure['standards'] << standard
        File.write STANDARD_DATA_FILENAME, JSON.dump(structure)
        stdout.puts JSON.dump(standard)
      elsif argv.first == 'show'
        # read in file
        raw_standards      = File.read STANDARD_DATA_FILENAME
        standards          = JSON.parse raw_standards

        # filter based on argv (category title:'Regular Expressions')
        search_info        = argv.last
        search_term, value = search_info.split(":")

        # print it to stdout
        if standards[search_term] == value
          stdout.puts JSON.dump(standards)
        end
      else
        raise "wat? #{argv.inspect}"
      end
    end

    def self.initialize_data_file(filename)
      return if File.exist? filename
      File.write filename, JSON.dump({'standards' => []})
    end
  end
end
