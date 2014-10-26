require 'spec_helper'

RSpec.describe 'Structure' do
  def structure(*attrs)
    Standards::Structure.new(*attrs)
  end

  def standard(*attrs)
    Standards::Standard.new(*attrs)
  end

  it 'represents itself as a hash' do # TODO: delete?
    structure = self.structure [{id: 12}]
    expect(structure.to_hash).to eq standards: [ {id: 12, standard: '', tags: []} ],
                                    hierarchy: {name: "root", :tags=>[], id: 1, parent_id: nil, subhierarchies: []}
  end

  describe 'equality' do
    it 'is not equal to non-instances of Structure' do
      expect(self.structure []).to_not eq nil
      expect(self.structure []).to_not eq 123
      expect(self.structure []).to_not eq Hash.new
      expect(self.structure []).to_not eq Array.new
    end

    it 'is equal when the array of standards and hierarchies is equal' do
      expect(self.structure []       ).to     eq self.structure([])
      expect(self.structure [{id: 1}]).to     eq self.structure([{id: 1}])
      expect(self.structure [{id: 1}]).to_not eq self.structure([{id: 2}])
      pending 'add hierarchies here'
      raise
    end
  end

  context 'managing the hierarchy' do
    it 'has a hierarchy tree, with a null-object root, with a default id of 1' do
      expect(self.structure.root_hierarchy.name     ).to eq 'root'
      expect(self.structure.root_hierarchy.id       ).to   eq 1
      expect(self.structure.root_hierarchy.parent_id).to   eq nil
    end

    # accepts attributes or instances of Hierarchy <-- might not want this
    context 'adding a hierarchy' do
      it 'returns the hierarchy' do
        s = self.structure
        returned = s.add_hierarchy name: 'somename'
        expect(returned.name).to eq 'somename'
      end

      specify 'when there is a parent id, adds it as the last child of the node with its parent id' do
        s = self.structure
        h1 = s.add_hierarchy name: 'h1', parent_id: 1
        h2 = s.add_hierarchy name: 'h2', parent_id: h1.id
        h3 = s.add_hierarchy name: 'h3', parent_id: h2.id
        h4 = s.add_hierarchy name: 'h4', parent_id: h1.id

        expect(s.root_hierarchy.subhierarchies).to eq [h1]
        expect(h1.subhierarchies).to eq [h2, h4]
        expect(h2.subhierarchies).to eq [h3]
        expect(h3.subhierarchies).to eq []
        expect(h4.subhierarchies).to eq []
      end

      specify 'when there is not a parent id, adds it as a child of root' do
        s = self.structure
        child = s.add_hierarchy name: 'child'
        expect(child.parent_id).to eq s.root_hierarchy.id
        expect(s.root_hierarchy.subhierarchies).to eq [child]
      end

      # hierarchy_enum      = structure.add_hierarchy name: 'Enumerable'
      # hierarchy_enum_each = structure.add_hierarchy name: 'Each', parent_id: hierarchy_enum.id, tags: ['enumerable', 'each']

      it 'can take a hierarchy or hierarchy attributes' do
        s      = self.structure
        child1 = s.add_hierarchy name: 'child1'
        child2 = s.add_hierarchy Standards::Hierarchy.new(name: 'child2', id: 3, parent_id: 1)
        expect(s.root_hierarchy.subhierarchies).to eq [child1, child2]
      end

      # TODO not sure I actually want to do this, kinda preferring the idea that you can only add a hierarchy w/o an id
      context 'when an id is provided' do
        it 'does not set the id' do
          s = self.structure
          child1 = s.add_hierarchy name: 'child', id: 123
          expect(child1.id).to eq 123
        end

        it 'blows up if there is overlap between ids' do
          pending 'I might get rid of the ability to have an initial id'
          raise
        end
      end

      context 'when an id is not provided' do
        it 'sets the id to be one more than the max of its standards ids' do
          s = self.structure
          child1 = s.add_hierarchy name: 'child', id: 123
          expect(child1.id).to eq 123
        end
      end
    end

    context 'iterating over hierarchies' do
      it 'yields each one, except the root' do
        s = self.structure
        s.each_hierarchy { raise "Should not have iterated" }

        seen = []
        h1   = s.add_hierarchy name: 'h1'
        h11  = s.add_hierarchy name: 'h11',  parent_id: h1.id
        h111 = s.add_hierarchy name: 'h111', parent_id: h11.id
        h2   = s.add_hierarchy name: 'h2'
        s.each_hierarchy { |h, a, &r| seen << [h.name, a.map(&:name)]; r.call }
        expect(seen).to eq [['h1',   ['root']],
                            ['h11',  ['h1', 'root']],
                            ['h111', ['h11', 'h1', 'root']],
                            ['h2',   ['root']]]
      end
    end
  end

  context 'Managing standards' do
    it 'has a collection of standards which default to an empty array' do
      structure = self.structure()
      expect(structure.standards).to eq []

      structure = self.structure [standard(id: 1)]
      expect(structure.standards).to eq [standard(id: 1)]
    end

    it 'initializes the standards via add_standards' do
      structure = self.structure [{id: 1}, standard(id: 2)]
      expect(structure.standards).to eq [standard(id: 1), standard(id: 2)]
    end

    context 'adding a standard' do
      it 'returns the standard' do
        structure = self.structure
        expect(structure.add_standard standard(id: 10)).to eq standard(id: 10)
      end

      it 'accepts attributes or instances of Standard' do
        standard = self.standard id: 12, standard: 'a', tags: ['b']

        structure1 = self.structure
        structure2 = self.structure
        standard1  = structure1.add_standard standard
        standard2  = structure2.add_standard standard.to_hash
        expect(standard1).to eq standard
        expect(standard2).to eq standard
      end

      it 'appends the standard to the list of standards' do
        structure = self.structure
        structure.add_standard standard(standard: 'a')
        structure.add_standard standard(standard: 'b')
        expect(structure.standards.map &:standard).to eq %w[a b]
      end

      context 'when an id is provided' do
        it 'does not set the id' do
          structure = self.structure
          expect(structure.add_standard(id: 12).id).to eq 12
        end

        it 'blows up if there is overlap between ids' do
          structure = self.structure
          structure.add_standard(id: 10)
          structure.add_standard(id: 11)             # no overlap
          expect { structure.add_standard(id: 10) }  # overlap
            .to raise_error ArgumentError, /overlap/
        end
      end

      context 'when an id is not provided' do
        it 'sets the id to 1 if there are no standards' do
          expect(self.structure.add_standard({}).id).to eq 1
        end

        it 'sets the id to be one more than the max of its standards ids' do
          structure = self.structure [{id: 100}]
          expect(structure.add_standard({}).id).to eq 101
        end
      end
    end

    describe 'select_standards' do
      it 'returns an array of standards that are selected by the block' do
        structure = self.structure [standard(tags: ['in']), standard(tags: ['not-in'])]
        standards = structure.select_standards { |standard| standard.tags == ['in'] }
        expect(standards.map &:tags).to eq [['in']]
      end
    end
  end
end
