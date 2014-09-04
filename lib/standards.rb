require 'json'
require 'standards/persistence'

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
    STANDARD_DATA_FILENAME = "standards.json"
    def self.call(argv, stdin, stdout, stderr)
      structure = Persistence.load STANDARD_DATA_FILENAME

      if argv.first == 'add'
        standard      = Standard.new standard: argv[1],
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
