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
      addHierarchy(d3Subhierarchies, dataHierarchy.subhierarchies[i], false)
    }
  }

  var Zipper = function(current, parentZipper, prevSiblings, nextSiblings) {
    this.current      = current
    this.parentZipper = parentZipper
    this.prevSiblings = prevSiblings
    this.nextSiblings = nextSiblings
  }
  Zipper.prototype.prevSibling = function() {
    if(!this.prevSibling[0]) return this
    var prevLen         = this.prevSiblings.length
    var newCurrent      = this.prevSiblings[prevLen-1]
    var newPrevSiblings = this.prevSiblings.slice(0, prevLen-2)
    var newNextSiblings = this.nextSiblings.concat([this.current])
    return new Zipper(newCurrent, this.parentZipper, newPrevSiblings, newNextSiblings)
  }
  Zipper.prototype.nextSibling = function() {
    return this
  }
  Zipper.prototype.parent = function() {
    return this
  }
  Zipper.prototype.firstChild = function() {
    var children = this.current.selectAll('.subhierarchies > .hierarchy')
    console.log(children)
    return new Zipper(newCurrent, this, [], newNextSiblings)
    return this
  }

  var Navigator = function(d3Root) {
    this.d3Root = d3Root
    this.zipper = new Zipper(d3Root, null, [], []) // change to Zipper.fromRoot(d3Root)
    this.markSelected(this.zipper.current)
  }
  Navigator.prototype.markSelected = function(d3Node) {
    d3Node.classed('selected', true)
  }
  Navigator.prototype.unmarkSelected = function(d3Node) {
    d3Node.classed('selected', false)
  }
  Navigator.prototype.toPrevSibling = function() {
    this.unmarkSelected(this.zipper.current)
    this.zipper = this.zipper.prevSibling()
    this.markSelected(this.zipper.current)
  }
  Navigator.prototype.toNextSibling = function() {
    this.unmarkSelected(this.zipper.current)
    this.zipper = this.zipper.nextSibling()
    this.markSelected(this.zipper.current)
  }
  Navigator.prototype.toParent = function() {
    this.unmarkSelected(this.zipper.current)
    this.zipper = this.zipper.parent()
    this.markSelected(this.zipper.current)
  }
  Navigator.prototype.toFirstChild = function() {
    this.unmarkSelected(this.zipper.current)
    this.zipper = this.zipper.firstChild()
    this.markSelected(this.zipper.current)
  }

  // would like to separate this piece by moving it into the script itself, but I don't know how to do that :/
  d3.json("/structure.json", function(structure) {
    var d3structure = d3.select('body').append('div').classed('structure', true)
    addHierarchy(d3structure, structure.hierarchy, true)
    var navigator = new Navigator(d3structure.select('.root'))

    // https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
    window.addEventListener("keydown", function (event) {
      if (event.defaultPrevented) {
        return; // Should do nothing if the key event was already consumed.
      }

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
    }, true);

  })
});
