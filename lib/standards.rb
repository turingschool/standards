require 'json'

module Standards
  class Structure
    def self.from_hash(structure_hash)
      standards =
        structure_hash.fetch('standards')
                      .map { |standard_hash|
                        Standard.new id:       standard_hash.fetch('id'),
                                     standard: standard_hash.fetch('standard'),
                                     tags:     standard_hash.fetch('tags')
                      }
      Structure.new standards
    end

    attr_accessor :standards
    def initialize(standards)
      self.standards = standards
    end

    def to_json
      as_json.to_json
    end

    def as_json
      {standards: standards.map(&:as_json)}
    end

    def add_standard(attributes)
      Standard.new(attributes)
              .tap { |standard| standards << standard }
    end
  end

  class Standard
    attr_accessor :id, :standard, :tags
    def initialize(attributes)
      self.id       = attributes.fetch :id
      self.standard = attributes.fetch :standard
      self.tags     = attributes.fetch :tags
    end

    def to_json
      as_json.to_json
    end

    def as_json
      {id: id, standard: standard, tags: tags}
    end
  end

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
        raw_structure = File.read STANDARD_DATA_FILENAME
        structure     = Structure.from_hash JSON.parse(raw_structure)
        standard      = structure.add_standard standard: argv[1],
                                               tags:     argv[2..-1].reject { |arg| arg == '--tag' },
                                               id:       1
        File.write STANDARD_DATA_FILENAME, structure.to_json
        stdout.puts standard.to_json
      elsif argv.first == 'select'
        initialize_data_file STANDARD_DATA_FILENAME
        # read in file
        raw_standards      = File.read STANDARD_DATA_FILENAME
        standards          = JSON.parse raw_standards


        # filter based on argv ('tag:tag1')
        search_info        = argv.last
        search_term, value = search_info.split(":")

        selected_standards = standards["standards"].select do |standard_hash|
          standard_hash["tags"].include?(value)
        end

        # print it to stdout
        stdout.puts JSON.dump(selected_standards)
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
