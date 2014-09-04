require 'spec_helper'

RSpec.describe 'Structure' do
  it 'has a collection of standards which default to an empty array' do
    structure = Structure.new
    expect(structure.standards).to eq []

    structure = Structure.new [Standard.new(id: 1)]
    expect(structure.standards).to eq [Standard.new(id: 1)]
  end

  it 'initializes the standards via add_standards' do
    structure = Structure.new [{id: 1}, Standard.new(id: 2)]
    expect(structure.standards).to eq [Standard.new(id: 1), Standard.new(id: 2)]
  end

  it 'represents itself as a hash' do
    structure = Structure.new [{id: 12}]
    expect(structure.to_hash).to eq(standards: [ {id: 12, standard: '', tags: []} ])
  end

  context 'adding a standard' do
    it 'returns the standard' do
      structure = Structure.new
      expect(structure.add_standard Standard.new(id: 10)).to eq Standard.new(id: 10)
    end

    it 'accepts attributes or instances of Standard' do
      standard = Standard.new id: 12, standard: 'a', tags: ['b']

      structure1 = Structure.new
      structure2 = Structure.new
      standard1  = structure1.add_standard standard
      standard2  = structure2.add_standard standard.to_hash
      expect(standard1).to eq standard
      expect(standard2).to eq standard
    end

    it 'appends the standard to the list of standards' do
      structure = Structure.new
      structure.add_standard Standard.new(standard: 'a')
      structure.add_standard Standard.new(standard: 'b')
      expect(structure.standards.map &:standard).to eq %w[a b]
    end

    context 'when an id is provided' do
      it 'does not set the id' do
        structure = Structure.new
        expect(structure.add_standard(id: 12).id).to eq 12
      end

      it 'blows up if there is overlap between ids' do
        structure = Structure.new
        structure.add_standard(id: 10)
        structure.add_standard(id: 11)             # no overlap
        expect { structure.add_standard(id: 10) }  # overlap
          .to raise_error ArgumentError, /overlap/
      end
    end

    context 'when an id is not provided' do
      it 'sets the id to 1 if there are no standards' do
        expect(Structure.new.add_standard({}).id).to eq 1
      end

      it 'sets the id to be one more than the max of its standards ids' do
        structure = Structure.new [{id: 100}]
        expect(structure.add_standard({}).id).to eq 101
      end
    end
  end

  describe 'equality' do
    it 'is not equal to non-instances of Structure' do
      expect(Structure.new []).to_not eq nil
      expect(Structure.new []).to_not eq 123
      expect(Structure.new []).to_not eq Hash.new
      expect(Structure.new []).to_not eq Array.new
    end

    it 'is equal when the array of standards is equal' do
      expect(Structure.new []       ).to     eq Structure.new([])
      expect(Structure.new [{id: 1}]).to     eq Structure.new([{id: 1}])
      expect(Structure.new [{id: 1}]).to_not eq Structure.new([{id: 2}])
    end
  end
end
