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
   <ul>
#{
structure.standards.map { |standard|
  "<li>#{standard.id} | #{standard.standard} | #{standard.tags.join ', '}</li>"
}.join("\n")
}
</ul>
  </body>
</html>
TEMPLATE
    end
  end
end
