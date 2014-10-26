"use strict";

// ==========  Hierarchy  ==========
var Hierarchy = function(d3hierarchy, d3view, d3subhierarchies, subhierarchies) {
  this.d3hierarchy      = d3hierarchy
  this.d3view           = d3view
  this.d3subhierarchies = d3subhierarchies
  this.subhierarchies   = subhierarchies
}

Hierarchy.d3build = function(d3RootHierarchy, jsonStructure) {
  d3RootHierarchy.classed('root', true)
  var d3buildRecursive = function(container, jsonHierarchy) {
    var d3Hierarchy      = container.append('div').classed('hierarchy', true)
    var d3View           = d3Hierarchy.append('div').classed('background', true).text(jsonHierarchy.name); // implies we are storing this data in the DOM... idk if that's good or bad
    var d3subhierarchies = d3Hierarchy.append('div').classed('subhierarchies', true)
    var subhierarchies   = []
    for(var i=0; i < jsonHierarchy.subhierarchies.length; ++i) {
      var child = d3buildRecursive(d3subhierarchies, jsonHierarchy.subhierarchies[i])
      subhierarchies.push(child)
    }
    return new Hierarchy(d3Hierarchy, d3View, d3subhierarchies, subhierarchies)
  }
  return d3buildRecursive(d3RootHierarchy, jsonStructure.hierarchy)
}

Hierarchy.prototype.subhierarchies = function() {
}

Hierarchy.prototype.markSelected = function() {
  this.d3hierarchy.classed('selected', true)
}

Hierarchy.prototype.unmarkSelected = function() {
  this.d3hierarchy.classed('selected', false)
}


// ==========  Zipper  ==========
var Zipper = function(current, parentZipper, prevSiblings, nextSiblings) {
  this.current      = current // a Hierarchy
  this.parentZipper = parentZipper
  this.prevSiblings = prevSiblings
  this.nextSiblings = nextSiblings
}

Zipper.prototype.prevSibling = function() {
  if(!this.prevSiblings[0]) return this
  var prevLen         = this.prevSiblings.length
  var newCurrent      = this.prevSiblings[prevLen-1]
  var newPrevSiblings = this.prevSiblings.slice(0, prevLen-1)
  var newNextSiblings = this.nextSiblings.concat([this.current])
  return new Zipper(newCurrent, this.parentZipper, newPrevSiblings, newNextSiblings)
}

Zipper.prototype.nextSibling = function() {
  if(!this.nextSiblings[0]) return this
  var nextLen         = this.nextSiblings.length
  var newCurrent      = this.nextSiblings[nextLen-1]
  var newNextSiblings = this.nextSiblings.slice(0, nextLen-1)
  var newPrevSiblings = this.prevSiblings.concat([this.current])
  return new Zipper(newCurrent, this.parentZipper, newPrevSiblings, newNextSiblings)
}

Zipper.prototype.parent = function() {
  return this.parentZipper || this
}

Zipper.prototype.firstChild = function() {
  var subhierarchies = this.current.subhierarchies
  if(!subhierarchies[0]) return this
  return new Zipper(subhierarchies[0], this, [], subhierarchies.slice(1, subhierarchies.length))
}


// ==========  Navigator (get rid of this soon, it does nothing over an around filter after the event)  ==========
var Navigator = function(d3Root) {
  this.zipper = new Zipper(d3Root, null, [], []) // change to Zipper.fromRoot(d3Root)
}

Navigator.prototype.toPrevSibling = function() {
  this.zipper.current.unmarkSelected()
  this.zipper = this.zipper.prevSibling()
  this.zipper.current.markSelected()
}

Navigator.prototype.toNextSibling = function() {
  this.zipper.current.unmarkSelected()
  this.zipper = this.zipper.nextSibling()
  this.zipper.current.markSelected()
}

Navigator.prototype.toParent = function() {
  this.zipper.current.unmarkSelected()
  this.zipper = this.zipper.parent()
  this.zipper.current.markSelected()
}

Navigator.prototype.toFirstChild = function() {
  this.zipper.current.unmarkSelected()
  this.zipper = this.zipper.firstChild()
  this.zipper.current.markSelected()
}


// depends on d3.js, you need this before it in the file:
// <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
document.addEventListener('DOMContentLoaded', function(){
  // ==========  Script  ==========
  d3.json("/structure.json", function(structure) {
    var d3structure   = d3.select('body').append('div').classed('structure', true)
    var rootHierarchy = Hierarchy.d3build(d3structure, structure)
    rootHierarchy.markSelected()
    var navigator = new Navigator(rootHierarchy)


    // would like to separate this piece by moving it into the script itself, but I don't know how to do that :/
    // based off of https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
    window.addEventListener("keydown", function (event) {
      if (event.defaultPrevented) { return } // Should do nothing if the key event was already consumed.

      // chars always come in as upercase ascii code b/c there are separate values
      // to identify things like whether shift has been pressed
      // you can get a list with `$ man ascii` or something like:
      // $ ruby -e '%w[h j k l o].map { |c| p [c, c.ord] }'
      switch (event.keyCode) {
        case 72: // h
          navigator.toParent()
          break
        case 74: // j
          navigator.toNextSibling()
          break
        case 75: // k
          navigator.toPrevSibling()
          break
        case 76: // l
          navigator.toFirstChild()
          break
        case 79: // 0
          break
        default:
          return // Quit when this doesn't handle the key event.
      }

      // Consume the event for suppressing "double action".
      event.preventDefault();
    });

  })
});
