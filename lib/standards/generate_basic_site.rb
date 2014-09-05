require 'erb'

module Standards
  module GenerateBasicSite
    def self.template
      @template ||= File.readlines(__FILE__)
                        .drop_while { |line| line != "__END__\n" }
                        .drop(1)
                        .join("")
    end

    def self.call(structure)
      standards = structure.standards
      all_tags  = standards.map { |s| s.tags }.flatten.uniq
      ERB.new(template, nil, "<>").result(binding)
    end

    def self.link_for(tag)
      %(<a class="tag" href="##{tag}">#{tag}</a>)
    end
  end
end


__END__
<!doctype html>
<html lang="en">
  <head>
    <title>Turing Standards</title>
  </head>
  <body>

    <div class="header">
      <div class="tags">
        <% all_tags.each { |tag| %><%= link_for tag %><% } %>
      </div>
    </div>

    <div class="standards">
      <% standards.map do |standard| %>
        <div class="standard">
          <div class="id"><%=   standard.id       %></div>
          <div class="body"><%= standard.standard %></div>
          <div class="tags">
            <% standard.tags.each { |tag| %><%= link_for tag %><% } %>
          </div>
        </div>
      <% end %>
    </div>
  </body>
</html>
