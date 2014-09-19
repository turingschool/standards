require 'spec_helper'

RSpec.describe 'Filter' do
  Filter   = Standards::Filter # <--   -.^
  Standard = Standards::Standard

  def filter_for(init_attributes)
    Filter.new(init_attributes)
  end

  def assert_allows(filter, standard)
    expect(filter.allow? standard).to eq true
  end

  def refute_allows(filter, standard)
    expect(filter.allow? standard).to eq false
  end

  context 'tag filters' do
    specify 'when there are no tag filters, it matches everything' do
      filter = filter_for tags: []
      assert_allows filter, Standard.new(tags: [])
      assert_allows filter, Standard.new(tags: ['a'])
    end

    specify 'when value is a string it allows standards tagged with the string' do
      filter = filter_for tags: ['b']
      assert_allows filter, Standard.new(tags: ['b'])
      assert_allows filter, Standard.new(tags: ['a', 'b', 'c'])
      refute_allows filter, Standard.new(tags: [])
      refute_allows filter, Standard.new(tags: ['a'])
      refute_allows filter, Standard.new(tags: ['ab'])
      refute_allows filter, Standard.new(tags: ['ba'])
    end

    specify 'when the value is a regex it allows standards with a tag that matches the regex' do
      filter = filter_for tags: [/b/]
      assert_allows filter, Standard.new(tags: ['b'])
      assert_allows filter, Standard.new(tags: ['a', 'b', 'c'])
      assert_allows filter, Standard.new(tags: ['ab'])
      assert_allows filter, Standard.new(tags: ['ba'])
      refute_allows filter, Standard.new(tags: [])
      refute_allows filter, Standard.new(tags: ['a'])
      refute_allows filter, Standard.new(tags: ['B'])
    end
  end

  describe 'to_proc' do
    it 'returns a proc that receives a standard and returns whether the standard allows the filter' do
      prc = filter_for(tags: ['a']).to_proc
      expect(prc).to be_a_kind_of Proc
      expect(prc.call(Standard.new tags: ['a'])).to eq true
      expect(prc.call(Standard.new tags: ['b'])).to eq false
    end
  end

  describe '==' do
    it 'is false when other is not a Filter' do
      filter = filter_for({})
      expect(filter).to     eq filter_for({})
      expect(filter).to_not eq nil
      expect(filter).to_not eq 123
      expect(filter).to_not eq BasicObject.new
    end

    it 'returns true when the initial options are ==' do
      expect(filter_for tags: ['a']).to     eq filter_for(tags: ['a'])
      expect(filter_for tags: ['a']).to_not eq filter_for(tags: ['b'])
    end

    it 'considers defaults' do
      expect(filter_for tags: []).to eq filter_for({})
    end
  end

  describe 'FindNone' do
    let(:find_none) { Standards::Filter::FindNone }

    it 'allows nothing' do
      expect(find_none.allow?                          ).to eq false
      expect(find_none.allow? 1                        ).to eq false
      expect(find_none.allow? Standard.new             ).to eq false
      expect(find_none.allow? Standard.new(tags: ['a'])).to eq false
    end

    it 'returns its allow method when invoking to_proc' do
      expect(find_none.to_proc.call                          ).to eq false
      expect(find_none.to_proc.call 1                        ).to eq false
      expect(find_none.to_proc.call Standard.new             ).to eq false
      expect(find_none.to_proc.call Standard.new(tags: ['a'])).to eq false
    end

    it 'inspects to its name' do
      expect(find_none.inspect).to eq 'Standards::Filter::FindNone'
    end

    it 'is only equal to itself' do
      expect(find_none).to eq find_none
      expect(find_none).to_not eq Object.new
      expect(find_none).to_not eq 1
      expect(find_none).to_not eq Standard.new
      expect(find_none).to_not eq Standard.new(tags: ['a'])
    end
  end
end
