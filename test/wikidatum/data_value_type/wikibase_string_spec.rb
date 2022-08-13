# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::WikibaseString do
  describe 'creating a DataValueType::WikibaseString' do
    it 'works' do
      string = Wikidatum::DataValueType::WikibaseString.new(
        string: 'Foobar'
      )

      assert string.is_a?(Wikidatum::DataValueType::WikibaseString)
    end
  end
end
