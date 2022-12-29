# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::CommonsMedia do
  describe 'creating a DataType::CommonsMedia' do
    it 'works' do
      string = Wikidatum::DataType::CommonsMedia.new(
        string: 'FooBar.jpg'
      )

      assert string.is_a?(Wikidatum::DataType::CommonsMedia)
    end
  end
end
