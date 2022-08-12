# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::GlobeCoordinate do
  describe 'creating a DataValueType::GlobeCoordinate' do
    it 'works' do
      globe_coordinate = Wikidatum::DataValueType::GlobeCoordinate.new(
        latitude: 52.516666666667,
        longitude: 13.383333333333,
        precision: 0.016666666666667,
        globe: 'http://www.wikidata.org/entity/Q2'
      )

      assert globe_coordinate.is_a?(Wikidatum::DataValueType::GlobeCoordinate)
    end
  end
end
