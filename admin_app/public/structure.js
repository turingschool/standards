"use strict";

// ==========  Hierarchy  ==========
var Hierarchy = function(d3hierarchy, d3view, d3subhierarchies, subhierarchies) {
  this.d3hierarchy      = d3hierarchy
  this.d3view           = d3view
  this.d3subhierarchies = d3subhierarchies
  this.subhierarchies   = subhierarchies
}

Hierarchy.buildTree = function(d3RootHierarchy, jsonStructure) {
  d3RootHierarchy.classed('root', true)
  var buildRecursive = function(container, jsonHierarchy) {
    var d3Hierarchy      = container.append('div').classed('hierarchy', true)
    var d3View           = d3Hierarchy.append('div').classed('background', true).text(jsonHierarchy.name); // implies we are storing this data in the DOM... idk if that's good or bad
    var d3subhierarchies = d3Hierarchy.append('div').classed('subhierarchies', true)
    var subhierarchies   = []
    for(var i=0; i < jsonHierarchy.subhierarchies.length; ++i) {
      var child = buildRecursive(d3subhierarchies, jsonHierarchy.subhierarchies[i])
      subhierarchies.push(child)
    }
    return new Hierarchy(d3Hierarchy, d3View, d3subhierarchies, subhierarchies)
  }
  return buildRecursive(d3RootHierarchy, jsonStructure.hierarchy)
}

Hierarchy.prototype.withSelected = function(value) {
  this.d3hierarchy.classed('selected', value)
  return this
}


// ==========  Zipper  ==========
var Zipper = function(current, parentZipper, prevSiblings, nextSiblings) {
  this.current      = current // a Hierarchy
  this.parentZipper = parentZipper
  this.prevSiblings = prevSiblings
  this.nextSiblings = nextSiblings
}

Zipper.fromRoot = function(rootHierarchy) {
  return new Zipper(rootHierarchy, null, [], [])
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


// ==========  Script  ==========
// would like to separate this piece by moving it into the script itself, but I don't know how to do that :/
document.addEventListener('DOMContentLoaded', function(){
  d3.json("/structure.json", function(structure) {
    var d3structure   = d3.select('body').append('div').classed('structure', true)
    var rootHierarchy = Hierarchy.buildTree(d3structure, structure).withSelected(true)
    var zipper = Zipper.fromRoot(rootHierarchy)

    var moveZipperTo = function(relative) {
      zipper.current.withSelected(false)
      zipper = zipper[relative]()
      zipper.current.withSelected(true)
    }

    // loosely based off of https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
    window.addEventListener("keydown", function (event) {
      if (event.defaultPrevented) { return } // do nothing if already consumed
      var asciiValue = String.fromCharCode(event.keyCode)
      if      (asciiValue == 'H' || event.keyIdentifier == 'Left' ) moveZipperTo('parent')
      else if (asciiValue == 'J' || event.keyIdentifier == 'Down' ) moveZipperTo('nextSibling')
      else if (asciiValue == 'K' || event.keyIdentifier == 'Up'   ) moveZipperTo('prevSibling')
      else if (asciiValue == 'L' || event.keyIdentifier == 'Right') moveZipperTo('firstChild')
      else return // irrelevant to us
      event.preventDefault();
    });

  })
});
