var chai   = require('chai')
var assert = chai.assert

// it('should return -1 when the value is not present', function(){
//   assert.equal(-1, [1,2,3].indexOf(5));
//   assert.equal(-1, [1,2,3].indexOf(0));
// })

var MockUI = function() {
  this.toldTo = []
}
MockUI.prototype.moveToParent = function() { this.toldTo.push('moveToParent') }

var StateMachine = function(ui) {
  this.ui = ui
}
StateMachine.prototype.input = function(char) {
  this.ui.moveToParent()
}

describe('User Inputs', function(){
  var ui = null
    , sm = null

  beforeEach(function(done){
    ui = new MockUI()
    sm = new StateMachine(ui)
    done()
  })

  describe('When in nav mode', function(){
    it('"h" moves to parent', function() {
      sm.input('h')
      assert.deepEqual(ui.toldTo, ['moveToParent']);
    })
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
    it('"h" moves to parent', function() {})
  })
  describe('When in edit mode', function(){
    it('treats return as "commit change"', function(){})
    it('treats escape as "discard change"', function(){})
    it('ignores all other inputs', function() {})
  })

})
