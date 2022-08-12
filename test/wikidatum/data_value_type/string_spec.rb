# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::String do
  describe 'creating a DataValueType::String' do
    it 'works' do
      string = Wikidatum::DataValueType::String.new(
        string: 'Foobar'
      )

      assert string.is_a?(Wikidatum::DataValueType::String)
    end
  end
end
