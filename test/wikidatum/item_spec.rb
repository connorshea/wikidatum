# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::Item do
  describe '.marshal_load' do
    it 'works with an item that has many types of datavalues' do
      item = Wikidatum::Item.marshal_load(JSON.parse(File.read('test/fixtures/q123.json')))

      assert item.is_a?(Wikidatum::Item)
    end
  end

  describe '#to_h' do
    it 'works with an item that has many types of datavalues' do
      item = Wikidatum::Item.marshal_load(JSON.parse(File.read('test/fixtures/q123.json')))

      assert item.to_h.is_a?(Hash)
    end
  end

  describe '#inspect' do
    it 'works with an item that has many types of datavalues' do
      item = Wikidatum::Item.marshal_load(JSON.parse(File.read('test/fixtures/q123.json')))

      assert item.inspect.is_a?(String)
    end
  end
end
