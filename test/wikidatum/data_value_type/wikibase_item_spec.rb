# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::WikibaseItem do
  describe 'creating a DataType::WikibaseItem' do
    it 'works' do
      wikibase_entity = Wikidatum::DataType::WikibaseItem.new(
        id: 'Q123'
      )

      assert wikibase_entity.is_a?(Wikidatum::DataType::WikibaseItem)
    end
  end
end
