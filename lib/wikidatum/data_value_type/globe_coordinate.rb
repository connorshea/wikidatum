# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Monolingual Text type datavalue JSON looks like this:
#
#   {
#     "datavalue": {
#       "value": {
#         "latitude": 52.516666666667,
#         "longitude": 13.383333333333,
#         "precision": 0.016666666666667,
#         "globe": "http:\/\/www.wikidata.org\/entity\/Q2"
#       },
#       "type": "globecoordinate"
#     }
#   }
class Wikidatum::DataValueType::GlobeCoordinate < Wikidatum::DataValueType::Base
  # @!visibility private
  def self.marshal_load(data_value_json)
    new(
      type: :globe_coordinate,
      value: {
        latitude: data_value_json['latitude'],
        longitude: data_value_json['longitude'],
        precision: data_value_json['precision'],
        globe: data_value_json['globe']
      }
    )
  end
end
