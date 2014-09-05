module Standards
  class GenerateBasicSite
    def self.call(structure)
      new(structure).call
    end

    def initialize(structure)
      self.structure = structure
    end

    def call
      @rendered ||= page_html
    end

    private

    attr_accessor :structure

    def page_html
      <<-HTML
        <!doctype html>
        <html lang="en">
          <head>
            <title>Google</title>
          </head>
          <body>
            #{standards_html}
          </body>
        </html>
      HTML
    end

    def standards_html
      html =  '<div class="standards">'
      html << '<div class="standard">'
      structure.standards.map { |standard|
        html << '<div class="id">'   << standard.id.to_s       << '</div>'
        html << '<div class="body">' << standard.standard.to_s << '</div>'
        html << '<div class="tags">'
        standard.tags.each do |tag|
          html << %'<div class="tag">#{tag}</div>'
        end
        html << '</div>'
        html << '</div>'
      }.join("\n")
      html << '</div>'
      html << '</div>'
    end
  end
end
