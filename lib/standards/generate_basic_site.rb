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
      body {
        font-family: "aktiv-grotesk-std", sans-serif;
        font-size: 14px;
        font-weight: 300;
        color: #323232;
      }

      p {
        display: block;
      }

      h3 {
        margin: 39.99996px 0 10px;
        font-size: 32px;
        font-weight: 200;
        letter-spacing: 0.01em;
      }

      h1 {
        margin-bottom: 0.2em;
        font-size: 32px;
        font-weight: 100;
        color: #05C2D1;
      }

      .header {
        background:     #262626;
        border-bottom:  solid 4px #05C2D1;
        color:          #FFF;
        font-size:      12px;
        font-weight:    700;
        min-height:     70px;
        width:          110%;
        padding:        30px;
        position:       relative;
          bottom:       10px;
          right:        10px;
        text-transform: uppercase;
      }

      .standards {
        padding: 0px 100px;
      }

      .main-tags {
        padding: 10px 0px;
        font-size: 18px;
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
    </div>

    <div class="standards">
      <div class="main-tags">
        <% all_tags.each { |tag| %><%= link_for tag %> <% } %>
      </div>

      <% standards.map do |standard| %>
        <div class="standard">
          <div class="body"><h1><%= standard.id %>. <%= standard.standard %></h1></div>
          <div class="tags">
            Tags: <% standard.tags.each { |tag| %><%= link_for tag %> <% } %>
          </div>
        </div>
      <% end %>
    </div>
  </body>
</html>
