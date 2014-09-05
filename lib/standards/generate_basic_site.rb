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
    <style>
      .header {
        width:            100%;
        background-color: green;
      }
    </style>
    <script>
      filterFromFragment = function() {
        var tagName = window.location.hash.replace(/^#/, '');
        filterStandardsByTag(tagName);
      }

      getAllStandards = function() {
        return document.querySelectorAll('.standards > .standard');
      };

      filterStandardsByTag = function(tagName) {
        if(!tagName)
          return;
        var standards = getAllStandards();
        for(var standardsIndex=0; standardsIndex < standards.length; ++standardsIndex) {
          var standard  = standards[standardsIndex];
          var tags      = standard.querySelectorAll('.tag'); // maybe normalize them by querying their children to get attributes and setting it on standard itself?
          var doHide    = true;
          for(var tagIndex=0; tagIndex < tags.length; ++tagIndex) {
            var tag = tags[tagIndex];
            if(tag.textContent == tagName) {
              doHide = false;
              break;
            };
          };
          if(doHide)
            standard.style.visibility = 'hidden';
          else
            standard.style.visibility = 'visible';
        };
      };

      window.onload = function() {
        var tags = document.querySelectorAll('.tags > .tag');
        for(var i=0; i<tags.length; ++i) {
          (function(tag) {
            tag.onclick = function(event) {
              window.location.hash = tag.textContent;
              filterFromFragment();
              event.preventDefault();
            };
          })(tags[i]);
        };
      };
    </script>
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
