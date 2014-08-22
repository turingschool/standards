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
        # load the json file
        # filter based on argv (category title:'Regular Expressions')
        # print it to stdout
      else
        raise "wat? #{argv.inspect}"
      end
    end
  end
end
