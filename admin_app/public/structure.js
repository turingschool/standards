"use strict";

// ==========  Hierarchy  ==========
var Hierarchy = function(domHierarchy, domView, domSubhierarchies, subhierarchies) {
  this.domHierarchy      = domHierarchy
  this.domView           = domView
  this.domSubhierarchies = domSubhierarchies
  this.subhierarchies    = subhierarchies
}
Hierarchy.buildTree = function(domRootHierarchy, jsonStructure) {
  var buildRecursive = function(domContainer, jsonHierarchy) {
    var domHierarchy      = jQuery('<div class="hierarchy"></div>')
    var domView           = jQuery('<div class="view"></div>').text(jsonHierarchy.name); // implies we are storing this data in the DOM... idk if that's good or bad
    var domSubhierarchies = jQuery('<div class="subhierarchies"></div>')

    domContainer.append(domHierarchy)
    domHierarchy.append(domView)
    domHierarchy.append(domSubhierarchies)

    var subhierarchies   = []
    for(var i=0; i < jsonHierarchy.subhierarchies.length; ++i) {
      var child = buildRecursive(domSubhierarchies, jsonHierarchy.subhierarchies[i])
      subhierarchies.push(child)
    }
    return new Hierarchy(domHierarchy, domView, domSubhierarchies, subhierarchies)
  }
  domRootHierarchy.addClass('root')
  return buildRecursive(domRootHierarchy, jsonStructure.hierarchy)
}
Hierarchy.prototype.withCursor = function(isCursor) {
  if(isCursor) this.domHierarchy.addClass('cursor')
  else         this.domHierarchy.removeClass('cursor')
}
Hierarchy.prototype.toggleChildVisibility = function() {
  if(this.childrenVisible()) this.domSubhierarchies.css('display', 'none')
  else                       this.domSubhierarchies.css('display', 'block')
}
Hierarchy.prototype.childrenVisible = function() {
  return this.domSubhierarchies.css('display') != 'none'
}
Hierarchy.prototype.parentOf = function(descendant) {
  for(var i=0; i < this.subhierarchies.length; ++i)
    if(this.subhierarchies[i] == descendant)
      return this;
  for(var i=0; i < this.subhierarchies.length; ++i) {
    var parent = this.subhierarchies[i].parentOf(descendant)
    if(parent)
      return parent
  }
  return null
}
Hierarchy.prototype.markSelected = function() {
  if(this.selectionIcon) {
    this.selectionIcon.css('display', 'block')
  } else {
    this.selectionIcon = jQuery('<svg class="selectionIcon"><polygon fill="yellow" stroke="black" stroke-width="1.8" points=" 20.877852522924734,23.090169943749473 15,20 9.12214747707527,23.090169943749473 10.244717418524232,16.545084971874736 5.489434837048464,11.909830056250527 12.061073738537633,10.954915028125264 14.999999999999998,5 17.938926261462363,10.954915028125262 24.510565162951536,11.909830056250524 19.755282581475768,16.545084971874736"></polygon></svg>')
    this.domView.append(this.selectionIcon)
  }
}
Hierarchy.prototype.markUnselected = function() {
  if(this.selectionIcon)
    this.selectionIcon.css('display', 'none')
}
Hierarchy.prototype.moveChildTo = function(child, newParent) {
  // remove child hierarchy
  for(var i=0; i < this.subhierarchies.length; ++i)
    if(this.subhierarchies[i] == child) {
      this.subhierarchies = this.subhierarchies
                                .slice(0, i)
                                .concat(this.subhierarchies.slice(i+1, this.subhierarchies.length))
    }
  // add child hierarchy to other parent
  newParent.subhierarchies = newParent.subhierarchies.concat([child])

  // ugh, cannot fucking figure out how to animate this thing with d3 or jQuery :(
  // http://jsfiddle.net/5936t/36/
  child.domHierarchy.appendTo(newParent.domSubhierarchies)
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
  this.rootHierarchy = rootHierarchy
  this.zipper        = Zipper.fromRoot(rootHierarchy)
  this.allSelected   = []
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
  // if(this.zipper.root)
  this.allSelected.push(this.zipper.current)
  this.zipper.current.markSelected()
}
UserInterface.prototype.unselectCurrent = function() {
  for(var i = 0; i < this.allSelected.length; ++i)
    if(this.allSelected[i] == this.zipper.current) {
      this.allSelected.splice(i, 1)
      --i
    }
  this.zipper.current.markUnselected()
}
UserInterface.prototype.isSelected = function() {
  for(var i = 0; i < this.allSelected.length; ++i) {
    if(this.allSelected[i] == this.zipper.current)
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
UserInterface.prototype.moveSelectedToCurrent = function() {
  var newParent = this.zipper.current
  for(var i = 0; i < this.allSelected.length; ++i) {
    var selected = this.allSelected[i]
    selected.markUnselected()
    rootHierarchy.parentOf(selected).moveChildTo(selected, newParent)
  }
  this.allSelected = []
}

// ==========  Script  ==========
// would like to separate this piece by moving it into the script itself, but I don't know how to do that :/

// declaring out here so I can access from console
var domStructure   = null
var rootHierarchy = null
var ui            = null
document.addEventListener('DOMContentLoaded', function(){
  jQuery.getJSON('/structure.json', function(structure) {
    domStructure  = jQuery('body .structure')
    rootHierarchy = Hierarchy.buildTree(domStructure, structure)
    ui            = new UserInterface(rootHierarchy)

    // loosely based off of https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
    window.addEventListener("keydown", function (event) {
      if (event.defaultPrevented) { return } // do nothing if already consumed
      var asciiValue = String.fromCharCode(event.keyCode)
      if      (asciiValue == 'H' || event.keyIdentifier == 'Left' ) ui.moveToParent()
      else if (asciiValue == 'J' || event.keyIdentifier == 'Down' ) ui.moveToNextSibling()
      else if (asciiValue == 'K' || event.keyIdentifier == 'Up'   ) ui.moveToPrevSibling()
      else if (asciiValue == 'L' || event.keyIdentifier == 'Right') ui.moveToFirstChild()
      else if (asciiValue == 'O' || event.keyIdentifier == 'Enter') ui.toggleChildVisibility()
      else if (asciiValue == 'S'                                  ) ui.toggleSelected()
      else if (asciiValue == 'M'                                  ) ui.moveSelectedToCurrent()
      else return // irrelevant to us
      event.preventDefault()
    });
  })
});
