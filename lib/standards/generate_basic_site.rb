module Standards
  module GenerateBasicSite
    def self.call(structure)
<<TEMPLATE
<!doctype html>
<html lang="en">
  <head>
    <title>Google</title>
  </head>
  <body>
    <div class="standards">
#{
structure.standards.map { |standard|
  html = '      <div class="standard">'
  html << '<div class="id">'   << standard.id.to_s       << '</div>'
  html << '<div class="body">' << standard.standard.to_s << '</div>'
  html << '<div class="tags">'
  standard.tags.each do |tag|
    html << %'<div class="tag">#{tag}</div>'
  end
  html << '</div>'
  html << '</div>'
}.join("\n")
}
    </div>
  </body>
</html>
TEMPLATE
    end
  end
end
