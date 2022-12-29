# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::WikibaseUrl do
  describe 'creating a DataType::WikibaseUrl' do
    it 'works' do
      string = Wikidatum::DataType::WikibaseUrl.new(
        string: 'https://example.com'
      )

      assert string.is_a?(Wikidatum::DataType::WikibaseUrl)
    end
  end
end
