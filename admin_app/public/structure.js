"use strict";

// ==========  Hierarchy  ==========
var Hierarchy = function(domHierarchy, domView, domSubhierarchies, subhierarchies) {
  this.domHierarchy      = domHierarchy
  this.domView           = domView
  this.domSubhierarchies = domSubhierarchies
  this.subhierarchies    = subhierarchies
  this._isCursor         = false
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
Hierarchy.prototype.isCursor = function(isCursor) {
  if(isCursor != undefined) {
    this._isCursor = isCursor
    if(isCursor) this.domHierarchy.addClass('cursor')
    else         this.domHierarchy.removeClass('cursor')
  }
  return this._isCursor
}
Hierarchy.prototype.toggleChildVisibility = function() {
  this.domSubhierarchies.toggle()
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
Hierarchy.prototype.printTree = function() {
  // to see the data structure
  var _printTree = function(hierarchy, depth) {
    var spacing = ''
    for(var i=0; i < depth; ++i) spacing += '  '
    console.log(spacing + hierarchy.domView.text())
    for(var i=0; i < hierarchy.subhierarchies.length; ++i)
      _printTree(hierarchy.subhierarchies[i], depth+1)
  }
  _printTree(this, 0)
}
Hierarchy.prototype.edit = function(finishedEditing) {
  var domView = this.domView // b/c "this" gets swapped out in functions all the time
  var text    = domView.text()
  domView.text("")
  var editBox = $('<input type="text" name="name"></input>')
  editBox.val(text)
         .appendTo(this.domView)
         .blur(function (event) {
           text = editBox.val()
           editBox.off('blur')
           editBox.remove()
           domView.text(text)
           window.focus()
           finishedEditing()
         })
         .focus()
}


var Tarzan = function(rootHierarchy, current) {
  this.rootHierarchy = rootHierarchy
  this.current       = current
}
Tarzan.prototype.parent = function() {
  var _parent = function(tree, current) {
    for(var i=0; i < tree.subhierarchies.length; ++i)
      if(tree.subhierarchies[i] == current)
        return tree;
    for(var i=0; i < tree.subhierarchies.length; ++i) {
      var parent = _parent(tree.subhierarchies[i], current)
      if(parent)
        return parent
    }
    return null
  }
  return _parent(rootHierarchy, this.current)
}
Tarzan.prototype.indexOfChild = function(parent, child) {
  for(var i = 0; i < parent.subhierarchies.length; ++i)
    if(parent.subhierarchies[i] == child)
      return i;
  return -1;
}
Tarzan.prototype.nextSibling = function() {
  var parent = this.parent()
  var index  = this.indexOfChild(parent, this.current)
  return parent.subhierarchies[index+1] // if it is last child, returns undefined
}
Tarzan.prototype.prevSibling = function() {
  var parent = this.parent()
  var index  = this.indexOfChild(parent, this.current)
  return parent.subhierarchies[index-1] // if it is last child, returns undefined
}
Tarzan.prototype.firstChild = function() {
  return this.current.subhierarchies[0]
}


// ==========  UserInterface  ==========
var UserInterface = function(rootHierarchy) {
  this.rootHierarchy = rootHierarchy
  this.current       = rootHierarchy
  this.allSelected   = []
  this.active        = true
  this.current.isCursor(true) // TODO should probably hide root and start at first child
}
UserInterface.prototype.moveToParent      = function() { this.moveTo('parent') }
UserInterface.prototype.moveToNextSibling = function() { this.moveTo('nextSibling') }
UserInterface.prototype.moveToPrevSibling = function() { this.moveTo('prevSibling') }
UserInterface.prototype.moveToFirstChild  = function() { this.moveTo('firstChild') }
UserInterface.prototype.moveTo = function(relative) {
  var newCurrent = new Tarzan(this.rootHierarchy, this.current)[relative]()
  if(newCurrent) {
    this.current.isCursor(false)
    this.current = newCurrent
    this.current.isCursor(true)
  }
}
UserInterface.prototype.toggleChildVisibility = function() {
  this.current.toggleChildVisibility()
}
UserInterface.prototype.selectCurrent = function() {
  this.allSelected.push(this.current)
  this.current.markSelected()
}
UserInterface.prototype.unselectCurrent = function() {
  for(var i = 0; i < this.allSelected.length; ++i)
    if(this.allSelected[i] == this.current) {
      this.allSelected.splice(i, 1)
      --i
    }
  this.current.markUnselected()
}
UserInterface.prototype.isSelected = function() {
  for(var i = 0; i < this.allSelected.length; ++i) {
    if(this.allSelected[i] == this.current)
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
  var newParent = this.current
  for(var i = 0; i < this.allSelected.length; ++i) {
    var selected = this.allSelected[i]
    selected.markUnselected()
    new Tarzan(rootHierarchy, selected).parent().moveChildTo(selected, newParent)
  }
  this.allSelected = []
}
UserInterface.prototype.printCurrent = function() {
  this.current.printTree()
}
UserInterface.prototype.editCurrent = function() {
  var self = this // omfgjswtf
  self.active = false
  this.current.edit(function() { self.active = true })
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
      var asciiValue = String.fromCharCode(event.keyCode)
      console.log("coming in: " + asciiValue)
      if (event.defaultPrevented) { return } // do nothing if already consumed
      console.log("  past defaultPrevented")
      if(!ui.active) { return }              // don't try to process input when other shit is going on
      console.log("  we are active!")
      if      (asciiValue == 'H' || event.keyIdentifier == 'Left' ) ui.moveToParent()
      else if (asciiValue == 'J' || event.keyIdentifier == 'Down' ) ui.moveToNextSibling()
      else if (asciiValue == 'K' || event.keyIdentifier == 'Up'   ) ui.moveToPrevSibling()
      else if (asciiValue == 'L' || event.keyIdentifier == 'Right') ui.moveToFirstChild()
      else if (asciiValue == 'O'                                  ) ui.toggleChildVisibility()
      else if (asciiValue == 'S'                                  ) ui.toggleSelected()
      else if (asciiValue == 'M'                                  ) ui.moveSelectedToCurrent()
      else if (asciiValue == 'P'                                  ) ui.printCurrent()
      else if (asciiValue == 'E'                                  ) ui.editCurrent()
      else return // irrelevant to us
      event.preventDefault()
    });
  })
});
