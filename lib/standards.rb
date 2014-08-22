require 'json'
class Category
  attr_accessor :title, :description

  def initialize
    yield self
  end

  def as_json
    {"title" => title, "description" => description}
  end
end

module Standards
  module Binary
    STANDARD_DATA_FILE = File.expand_path("../../standards.json", __FILE__)
    def self.call(argv, stdin, stdout, stderr)
      if argv.first == 'define'
        filename = argv.last
        category = eval File.read(filename)
        File.write STANDARD_DATA_FILE, JSON.dump(category.as_json)
      elsif argv.first == 'show'
        # read in file
        raw_standards      = File.read STANDARD_DATA_FILE
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
  end
end
