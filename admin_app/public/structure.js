"use strict";

// depends on d3.js, you need this before it in the file:
// <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
document.addEventListener('DOMContentLoaded', function(){
  var addHierarchy = function(container, dataHierarchy, isRoot) {
    var d3Hierarchy = container.append('div').classed('hierarchy', true)
    if(isRoot) d3Hierarchy.classed('root', true)
    d3Hierarchy.append('div').classed('background', true).text(dataHierarchy.name);
    var d3Subhierarchies = d3Hierarchy.append('div').classed('subhierarchies', true)
    for(var i=0; i < dataHierarchy.subhierarchies.length; ++i) {
      d3Subhierarchies.call(function(fuck) {
        addHierarchy(fuck, dataHierarchy.subhierarchies[i], false)
      })
    }
  }

  d3.json("/structure.json", function(structure) {
    var d3Container = d3.select('body').append('div').classed('structure', true)
    addHierarchy(d3Container, structure.hierarchy, true)
    var selected = d3Container.select('.root').classed('selected', true)
  })
});
