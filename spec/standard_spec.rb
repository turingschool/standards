require 'standards'

RSpec.describe 'Standard' do
  let(:id)              { 12 }
  let(:standard_string) { 'some standard'.freeze }
  let(:tags)            { ['a', 'b'].map(&:freeze).freeze }

  let(:standard) { Standard.new id: id, standard: standard_string, tags: tags }

  describe 'attributes' do
    it 'has an id, standard, and tags' do
      expect(standard.id      ).to eq id
      expect(standard.standard).to eq standard_string
      expect(standard.tags    ).to eq tags
    end

    it 'defaults id to nil' do
      expect(Standard.new.id).to eq nil
    end

    it 'defaults standard to empty string' do
      expect(Standard.new.standard).to eq ''
    end

    it 'defaults tags to empty array' do
      expect(Standard.new.tags).to eq []
    end
  end

  it 'can be represented as a hash' do
    expect(standard.to_hash).to eq({id: id, standard: standard_string, tags: tags})
  end

  it 'can be turned into json' do
    expected_json = JSON.parse standard.to_json
    actual_json   = JSON.parse %'{"id":#{id}, "standard":#{standard_string.inspect}, "tags":#{tags.inspect}}'
    expect(actual_json).to eq expected_json
  end

  describe 'equality' do
    it 'is not equal when the other object is not a Standard' do
      expect(Standard.new).to     eq Standard.new
      expect(Standard.new).to_not eq nil
      expect(Standard.new).to_not eq 123
      expect(Standard.new).to_not eq Hash.new
      expect(Standard.new).to_not eq Array.new
    end

    it 'is equal when any attribute is not equal' do
      expect(Standard.new id: 1          ).to     eq Standard.new id: 1
      expect(Standard.new id: 1          ).to_not eq Standard.new id: 2

      expect(Standard.new standard: 'a'  ).to     eq Standard.new standard: 'a'
      expect(Standard.new standard: 'a'  ).to_not eq Standard.new standard: 'b'

      expect(Standard.new tags:     ['a']).to     eq Standard.new tags: ['a']
      expect(Standard.new tags:     ['a']).to_not eq Standard.new tags: []
    end
  end
end
