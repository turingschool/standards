require 'spec_helper'

RSpec.describe 'Binary::ParseSelect' do
  def call(argv)
    Standards::ParseSelect.call(argv)
  end

  def filter_for(options)
    Standards::Filter.new(options)
  end

  context 'single filter' do
    it 'returns a filter for tag:some_tag' do
      filter = call(['tag:some_tag'])
      expect(filter).to eq filter_for(tags: ['some_tag'])
    end
  end

  context 'multiple filters' do
    it 'creates a conjunction filter for each input' do
      filter = call(['tag:tag1', 'tag:tag2'])
      expect(filter).to eq filter_for(tags: ['tag1', 'tag2'])
    end
  end

  context 'it raises errors on' do
    example 'unknown filters' do
      expect { call ['idk:something'] }.to raise_error ArgumentError, /Unknown attribute/
    end

    example 'non key:value pairs' do
      expect { call ['attributevalue'] }.to raise_error SyntaxError, /key:value/
    end
  end
end
