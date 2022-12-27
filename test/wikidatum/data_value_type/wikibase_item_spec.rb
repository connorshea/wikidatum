# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::WikibaseItem do
  describe 'creating a DataValueType::WikibaseItem' do
    it 'works' do
      wikibase_entity = Wikidatum::DataValueType::WikibaseItem.new(
        entity_type: 'item',
        numeric_id: 123,
        id: 'Q123'
      )

      assert wikibase_entity.is_a?(Wikidatum::DataValueType::WikibaseItem)
    end
  end
end
