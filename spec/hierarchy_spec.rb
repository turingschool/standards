require 'spec_helper'

RSpec.describe 'hierarchy' do
  def self.next_id
    @current_id ||= 0
    @current_id += 1
  end

  def h(name, attributes={})
    attributes[:parent_id] ||= 1
    attributes[:id]        ||= self.class.next_id
    attributes[:name]        = name
    Standards::Hierarchy.new attributes
  end

  describe 'attributes' do
    it 'has an id, parent_id, name, tags, and subhierarchies' do
      child = h 'child'
      hierarchy = Standards::Hierarchy.new(id: 100, parent_id: 200, name: 'somename', tags: %w[x y z], subhierarchies: [child])
      expect(hierarchy.id            ).to eq 100
      expect(hierarchy.parent_id     ).to eq 200
      expect(hierarchy.name          ).to eq 'somename'
      expect(hierarchy.tags          ).to eq %w[x y z]
      expect(hierarchy.subhierarchies).to eq [child]
    end

    it 'must explicitly pass a name, id, and parent_id' do
      Standards::Hierarchy.new id: 1, parent_id: 1, name: ''
      expect { Standards::Hierarchy.new        parent_id: 1, name: '' }.to raise_error ArgumentError, /\bid\b/
      expect { Standards::Hierarchy.new id: 1,               name: '' }.to raise_error ArgumentError, /\bparent_id\b/
      expect { Standards::Hierarchy.new id: 1, parent_id: 1           }.to raise_error ArgumentError, /\bname\b/
    end
  end


  # TODO: rename to something that makes it more clear that this is for persistence with the timeline
  # e.g. to_event_data
  describe 'to_hash' do
    it 'returns the attributes, but not thie subhierarchies' do
      child = h 'child'
      hierarchy = Standards::Hierarchy.new(id: 100, parent_id: 200, name: 'somename', tags: %w[x y z], subhierarchies: [child])
      expect(hierarchy.to_hash).to eq name: 'somename', tags: %w[x y z], id: 100, parent_id: 200
    end
  end

  describe 'adding a child' do
    before {
      @root  = h 'root'
      expect(@root.id).to be_a_kind_of Fixnum # just making sure we don't arbitrarily pass
      @child = h("example")
      @root.add_subhierarchy(@child)
    }

    it 'updates the child\'s parent id' do
      expect(@child.parent_id).to eq @root.id
    end

    it 'adds the child to the list of subhierarchies' do
      expect(@root.subhierarchies.first).to eq @child
    end
  end


  describe 'inspect' do
    it 'is a single line when there are no children' do
      root = h 'root'
      expect(root.inspect).to eq '#<Standards::Hierarchy "root">'
    end

    it 'prettily displays the nesting of the children' do
      root = h("root")
      h1   =  h("1")
      h11  =   h("11")
      h111 =    h("111")
      h2   =  h("2")
      h21  =   h("21")
      h22  =   h("22")
      root.add_subhierarchy(h1).add_subhierarchy(h2)
      h1.add_subhierarchy(h11)
      h11.add_subhierarchy(h111)
      h2.add_subhierarchy(h21).add_subhierarchy(h22)
      expect(root.inspect).to eq "#<Standards::Hierarchy\n"\
                                 "  \"root\"\n"\
                                 "    \"1\"\n"\
                                 "      \"11\"\n"\
                                 "        \"111\"\n"\
                                 "    \"2\"\n"\
                                 "      \"21\"\n"\
                                 "      \"22\"\n"\
                                 ">"

    end
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

    it 'when it has no tags, it matches nothing' do
      expect(h('no tags').standards_filter).to eq Standards::Filter::FindNone
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
      root.add_subhierarchy(h1).add_subhierarchy(h2)
      h1.add_subhierarchy(h11).add_subhierarchy(h12)
      h2.add_subhierarchy(h21).add_subhierarchy(h22)
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


  describe 'equality' do
    let(:id)        { 123        }
    let(:name)      { 'name'     }
    let(:parent_id) { 456        }
    let(:tags)      { ['a', 'b'] }
    let(:h1)        { Standards::Hierarchy.new name: name, id: id, tags: tags, parent_id: parent_id }
    let(:h2)        { Standards::Hierarchy.new name: name, id: id, tags: tags, parent_id: parent_id }

    def make_child
      Standards::Hierarchy.new id: 999, parent_id: nil, name: 'child'
    end

    before do
      h1.add_subhierarchy make_child
      h2.add_subhierarchy make_child
      expect(h1).to eq h2
    end

    it 'mmust be a hierarchy' do
      expect(h1).to_not eq 1
      expect(h1).to_not eq BasicObject.new
      expect(h1).to_not eq nil
    end

    it 'must have the same id' do
      h1.id += 1
      expect(h1).to_not eq h2
    end

    it 'must have the same name' do
      h1.name = h1.name.reverse
      expect(h1).to_not eq h2
    end

    it 'does not need the same parent id' do
      h1.parent_id = h1.parent_id.next
      expect(h1).to eq h2
    end

    it 'must have the same tags, but in any order' do
      h1.tags = h1.tags.reverse
      expect(h1).to eq h2

      h1.tags = [h1.tags.first]
      expect(h1).to_not eq h2
    end

    it 'must have the same subhierarchies, in the same order' do
      h1.subhierarchies.pop
      expect(h1).to_not eq h2
    end
  end
end
