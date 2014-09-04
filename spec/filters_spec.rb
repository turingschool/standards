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
end
