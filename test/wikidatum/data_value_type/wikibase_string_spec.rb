# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::WikibaseString do
  describe 'creating a DataType::WikibaseString' do
    it 'works' do
      string = Wikidatum::DataType::WikibaseString.new(
        string: 'Foobar'
      )

      assert string.is_a?(Wikidatum::DataType::WikibaseString)
    end
  end
end
