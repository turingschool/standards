require 'erb'

module Standards
  class GenerateBasicSite
    def self.template
      @template ||= File.readlines(__FILE__)
                        .drop_while { |line| line != "__END__\n" }
                        .drop(1)
                        .join("")
    end

    def self.call(structure)
      new(structure).call
    end

    def initialize(structure)
      self.structure = structure
    end

    def call
      @rendered ||= ERB.new(self.class.template, nil, "<>").result(binding)
    end

    private

    attr_accessor :structure
  end
end


__END__
<!doctype html>
<html lang="en">
  <head>
    <title>Turing Standards</title>
  </head>
  <body>
    <div class="standards">
      <% structure.standards.map do |standard| %>
        <div class="standard">
          <div class="id"><%=   standard.id       %></div>
          <div class="body"><%= standard.standard %></div>
          <div class="tags">
            <% standard.tags.each do |tag| %>
             <div class="tag"><%= tag %></div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
  </body>
</html>
