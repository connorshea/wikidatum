# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::MonolingualText do
  describe 'creating a DataType::MonolingualText' do
    it 'works' do
      monolingual_text = Wikidatum::DataType::MonolingualText.new(
        language: 'en',
        text: 'Foobar'
      )

      assert monolingual_text.is_a?(Wikidatum::DataType::MonolingualText)
    end
  end
end
