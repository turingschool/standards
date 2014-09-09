require 'spec_helper'

module Standards
  class Hierarchy
    attr_reader :name, :subhierarchies

    def initialize(name)
      @name           = name
      @subhierarchies = []
    end

    def root?
      !name
    end

    def name
      @name
    end

    def size
      @subhierarchies.size
    end

    def add(hierarchy)
      subhierarchies << hierarchy
      self
    end

    def depth_first(&block)
      _depth_first([], block)
    end

    def inspect
      "#<Standards::Hierarchy #{name}>"
    end

    protected

    def _depth_first(ancestry, block)
      block.call self, ancestry do
        subhierarchies.each do |subhierarchy|
          subhierarchy._depth_first [self, *ancestry], block
        end
      end
    end
  end
end

RSpec.describe 'hierarchy' do
  def h(name)
    Standards::Hierarchy.new name
  end

  it 'is a root if it has no name' do
    expect(h(nil)).to be_root
  end

  it 'allows nesting of hierarchies' do
    root  = h nil
    child = h("example")
    expect(root.size).to eq 0
    root.add(child)
    expect(root.size).to eq 1
    expect(root.subhierarchies.first).to eq child
  end

  it 'maps categories to a set of tags that define which standards apply'

  describe 'depth_first' do
    let(:root) { h(nil)    }
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

    it 'is a depth first traversal, providing the category/ancestry/recurser' do
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
