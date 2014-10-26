require 'sinatra'
module Standards
  class AdminApp < Sinatra::Base

html = <<HTML
<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta content='width=device-width, initial-scale=1' name='viewport'>
    <title>Standards Admin App</title>
    <style  type="text/css">
    </style>
    <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
    <script type="text/javascript">
      document.addEventListener('DOMContentLoaded', function(){
        var data = ['a', 'b', 'c'];
        d3.select('body')
          .append('svg')
          .selectAll('g.hierarchy')
          .data(data)
          .enter()
            // group of hierarchies
            .append('g')
            .attr("transform", function(d, i) { return "translate(0,"+(i*60)+")"; })
            .call(function(group) {
              // rectangles
              group.append('rect')
                   .style('fill', 'green')
                   .attr('width', 100)
                   .attr('height', 50)
            })
            .call(function(group) {
              // text
              group.append('text')
                   .text(function(d) { return d; })
                   .attr('fill',        'white')
                   .attr('font-family', 'sans-serif')
                   .attr('font-size',   20)
                   .attr('x',           20)
                   .attr('y',           30)
            })
      });
    </script>
  </head>
  <body>
    <h1>Standards and Hierarchy</h1>
  </body>
</html>
HTML

    get '/' do
      env['standards']['timeline']
      env['standards']['structure']
      html
    end
  end
end
