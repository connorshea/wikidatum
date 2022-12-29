# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::ExternalId do
  describe 'creating a DataType::ExternalId' do
    it 'works' do
      string = Wikidatum::DataType::ExternalId.new(
        string: '123'
      )

      assert string.is_a?(Wikidatum::DataType::ExternalId)
    end
  end
end
