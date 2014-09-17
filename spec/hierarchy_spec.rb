require 'spec_helper'

RSpec.describe 'hierarchy' do
  def h(name, other_attributes={})
    other_attributes[:name] = name
    Standards::Hierarchy.new other_attributes
  end

  it 'must have a name' do
    expect { h nil }.to raise_error ArgumentError, /name/
  end

  it 'allows nesting of hierarchies' do
    root  = h 'root'
    child = h("example")
    expect(root.size).to eq 0
    root.add(child)
    expect(root.size).to eq 1
    expect(root.subhierarchies.first).to eq child
  end

  describe 'associating standards to a hierarchy' do
    # It's possible that we'll eventually want to use specific ids instead of tags
    # but since we don't have it in place yet, we don't really know, so just roll with this for now
    it 'maps hierarchies to a set of tags' do
      expect(h('no tags',  tags: []).tags).to eq []
      expect(h('has tags', tags: ['a', 'b']).tags).to eq ['a', 'b']
    end

    it 'its tags default to empty when they are not passed' do
      expect(h('no tags').tags).to eq []
    end

    it 'when it has no tags, it has a universally matching standards_filter' do
      allow_everything = Standards::Filter.new({})
      expect(h('no tags').standards_filter).to eq allow_everything
    end

    it 'when it has tags, it has a standards_filter that will select its tags' do
      must_be_tagged_with_a_and_b = Standards::Filter.new tags: ['a', 'b']
      expect(h('has tags', tags: ['a', 'b']).standards_filter).to eq must_be_tagged_with_a_and_b
    end
  end

  describe 'depth_first' do
    let(:root) { h("root") }
    let(:h1)   {  h("1")   }
    let(:h11)  {   h("11") }
    let(:h12)  {   h("12") }
    let(:h2)   {  h("2")   }
    let(:h21)  {   h("21") }
    let(:h22)  {   h("22") }
    before do
      root.add(h1).add(h2)
      h1.add(h11).add(h12)
      h2.add(h21).add(h22)
    end

    it 'is a depth first traversal, providing the hierarchy/ancestry/recurser' do
      seen = []
      root.depth_first do |hierarchy, ancestry, &recurse|
        seen << [hierarchy, ancestry]
        recurse.call
      end
      expect(seen).to eq [
        [root,        []],
        [h1,      [root]],
        [h11,  [h1,root]],
        [h12,  [h1,root]],
        [h2,      [root]],
        [h21,  [h2,root]],
        [h22,  [h2,root]],
      ]
    end

    it 'uses the recurser to invoke the next level of iteration' do
      seen = []
      root.depth_first do |hierarchy, ancestry, &recurse|
        seen << [hierarchy, ancestry]
        recurse.call unless ancestry.size == 1
      end
      expect(seen).to eq [
        [root,     []],
        [h1,   [root]],
        [h2,   [root]],
      ]
    end
  end
end
