require 'spec_helper'

RSpec.describe 'Structure' do
  def structure(*attrs)
    Standards::Structure.new(*attrs)
  end

  def standard(*attrs)
    Standards::Standard.new(*attrs)
  end

  context 'hierarchy' do
    it 'has a hierarchy tree, with a null-object root, with a default id of 1'
    # accepts attributes or instances of Hierarchy <-- might not want this
    context 'adding a hierarchy' do
      it 'returns the hierarchy'
      specify 'when there is a parent id, adds it as the last child of the node with its parent id'
      specify 'when there is not a parent id, adds it as a child of root and sets the parent id'
      specify 'when the parent id DNE, it blows up'
      context 'when an id is provided' do
        it 'does not set the id'
        it 'blows up if there is overlap between ids'
      end
      context 'when an id is not provided' do
        it 'sets the id to be one more than the max of its standards ids'
      end
    end
  end

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

  it 'represents itself as a hash' do
    structure = self.structure [{id: 12}]
    expect(structure.to_hash).to eq(standards: [ {id: 12, standard: '', tags: []} ])
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

  describe 'select_standards' do
    it 'returns an array of standards that are selected by the block' do
      structure = self.structure [standard(tags: ['in']), standard(tags: ['not-in'])]
      standards = structure.select_standards { |standard| standard.tags == ['in'] }
      expect(standards.map &:tags).to eq [['in']]
    end
  end
end
