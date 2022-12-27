# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::Quantity do
  describe 'creating a DataValueType::Quantity' do
    it 'works' do
      quantity = Wikidatum::DataValueType::Quantity.new(
        amount: "+10.38",
        unit: 'http://www.wikidata.org/entity/Q712226'
      )

      assert quantity.is_a?(Wikidatum::DataValueType::Quantity)
    end
  end
end
