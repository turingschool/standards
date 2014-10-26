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
    var d3View           = d3Hierarchy.append('div').classed('view', true).text(jsonHierarchy.name); // implies we are storing this data in the DOM... idk if that's good or bad
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
Hierarchy.prototype.withCursor = function(value) {
  this.d3hierarchy.classed('cursor', value)
}
Hierarchy.prototype.toggleChildVisibility = function() {
  if(this.childrenVisible())
    this.d3subhierarchies.style('display', 'none')
  else
    this.d3subhierarchies.style('display', null)
}
Hierarchy.prototype.childrenVisible = function() {
  return this.d3subhierarchies.style('display') != 'none'
}

// http://dillieodigital.wordpress.com/2013/01/16/quick-tip-how-to-draw-a-star-with-svg-and-javascript/
var addStar = function(d3svg) {
  var arms        = 5
  var innerRadius = 5
  var outerRadius = 10
  var centerX     = 15
  var centerY     = 15
  var points      = ""
  var angle = Math.PI / arms
  for(var i = 0; i < 2 * arms; i++) {
     var radius = (i & 1) == 0 ? outerRadius : innerRadius
     var currX = centerX + Math.cos(i*angle+Math.PI/2-angle) * radius
     var currY = centerY + Math.sin(i*angle+Math.PI/2-angle) * radius
     points += " " + currX + "," + currY
  }
  d3svg.append('polygon')
       .attr('fill', 'yellow')
       .attr('stroke', 'black')
       .attr('stroke-width', '1.8')
       .attr('points', points)
}
Hierarchy.prototype.markSelected = function() {
  if(this.selectionIcon) {
    this.selectionIcon.classed('selectionIcon', true).style('display', null)
  } else {
    this.selectionIcon = this.d3view.append('svg').classed('selectionIcon', true)
    addStar(this.selectionIcon)
  }
}
Hierarchy.prototype.markUnselected = function() {
  if(this.selectionIcon)
    this.selectionIcon.classed('selectionIcon', false).style('display', 'none')
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


// ==========  UserInterface  ==========
var UserInterface = function(rootHierarchy) {
  this.zipper = Zipper.fromRoot(rootHierarchy)
  this.selected = []
  this.setCursor(true)
}
UserInterface.prototype.setCursor = function(bool) {
  this.zipper.current.withCursor(bool)
}
UserInterface.prototype.moveZipperTo = function(relative) {
  this.setCursor(false)
  this.zipper = this.zipper[relative]()
  this.setCursor(true)
}
UserInterface.prototype.moveToParent = function() {
  this.moveZipperTo('parent')
}
UserInterface.prototype.moveToNextSibling = function() {
  this.moveZipperTo('nextSibling')
}
UserInterface.prototype.moveToPrevSibling = function() {
  this.moveZipperTo('prevSibling')
}
UserInterface.prototype.moveToFirstChild  = function() {
  this.moveZipperTo('firstChild')
}
UserInterface.prototype.toggleChildVisibility = function() {
  this.zipper.current.toggleChildVisibility()
}
UserInterface.prototype.selectCurrent = function() {
  this.selected.push(this.zipper.current)
  this.zipper.current.markSelected()
}
UserInterface.prototype.unselectCurrent = function() {
  for(var i = 0; i < this.selected.length; ++i)
    if(this.selected[i] == this.zipper.current) {
      this.selected.splice(i, 1)
      --i
    }
  this.zipper.current.markUnselected()
}
UserInterface.prototype.isSelected = function() {
  for(var i = 0; i < this.selected.length; ++i) {
    if(this.selected[i] == this.zipper.current)
      return true
  }
  return false
}
UserInterface.prototype.toggleSelected = function() {
  if(this.isSelected())
    this.unselectCurrent()
  else
    this.selectCurrent()
}


// ==========  Script  ==========
// would like to separate this piece by moving it into the script itself, but I don't know how to do that :/
document.addEventListener('DOMContentLoaded', function(){
  d3.json("/structure.json", function(structure) {
    var d3structure   = d3.select('body .structure')
    var rootHierarchy = Hierarchy.buildTree(d3structure, structure)
    var ui            = new UserInterface(rootHierarchy)

    // loosely based off of https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
    window.addEventListener("keydown", function (event) {
      if (event.defaultPrevented) { return } // do nothing if already consumed
      var asciiValue = String.fromCharCode(event.keyCode)
      if      (asciiValue == 'H' || event.keyIdentifier == 'Left' ) ui.moveToParent()
      else if (asciiValue == 'J' || event.keyIdentifier == 'Down' ) ui.moveToNextSibling()
      else if (asciiValue == 'K' || event.keyIdentifier == 'Up'   ) ui.moveToPrevSibling()
      else if (asciiValue == 'L' || event.keyIdentifier == 'Right') ui.moveToFirstChild()
      else if (asciiValue == 'O' || event.keyIdentifier == 'Enter') ui.toggleChildVisibility()
      else if (asciiValue == 'X'                                  ) ui.toggleSelected()
      else return // irrelevant to us
      event.preventDefault();
    });

  })
});
