# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::Quantity do
  describe 'creating a DataType::Quantity' do
    it 'works' do
      quantity = Wikidatum::DataType::Quantity.new(
        amount: "+10.38",
        unit: 'http://www.wikidata.org/entity/Q712226'
      )

      assert quantity.is_a?(Wikidatum::DataType::Quantity)
    end
  end
end
