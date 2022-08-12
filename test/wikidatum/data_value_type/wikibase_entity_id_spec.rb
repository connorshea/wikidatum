# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::WikibaseEntityId do
  describe 'creating a DataValueType::WikibaseEntityId' do
    it 'works' do
      wikibase_entity = Wikidatum::DataValueType::WikibaseEntityId.new(
        entity_type: 'item',
        numeric_id: 123,
        id: 'Q123'
      )

      assert wikibase_entity.is_a?(Wikidatum::DataValueType::WikibaseEntityId)
    end
  end
end
