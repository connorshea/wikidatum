# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::MonolingualText do
  describe 'creating a DataValueType::MonolingualText' do
    it 'works' do
      monolingual_text = Wikidatum::DataValueType::MonolingualText.new(
        language: 'en',
        text: 'Foobar'
      )

      assert monolingual_text.is_a?(Wikidatum::DataValueType::MonolingualText)
    end
  end
end
