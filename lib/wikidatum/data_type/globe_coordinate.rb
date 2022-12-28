# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The Globe Coordinate type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P740",
#     "data-type": "globe-coordinate"
#   },
#   "value": {
#     "type": "value",
#     "content": {
#       "latitude": 38.8977,
#       "longitude": -77.0365,
#       "precision": 0.0001,
#       "globe": "http://www.wikidata.org/entity/Q2"
#     }
#   }
# }
# ```
class Wikidatum::DataType::GlobeCoordinate
  # @return [Float]
  attr_reader :latitude

  # @return [Float]
  attr_reader :longitude

  # @return [Float]
  attr_reader :precision

  # @return [String] A URL (usually in the same Wikibase instance) representing the given globe model (e.g. Earth).
  attr_reader :globe

  # @param latitude [Float]
  # @param longitude [Float]
  # @param precision [Float]
  # @param globe [String]
  # @return [void]
  def initialize(latitude:, longitude:, precision:, globe:)
    @latitude = latitude
    @longitude = longitude
    @precision = precision
    @globe = globe
  end

  # @return [Hash]
  def to_h
    {
      latitude: @latitude,
      longitude: @longitude,
      precision: @precision,
      globe: @globe
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'globe-coordinate'
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataType::Base.new(
      type: :globe_coordinate,
      value: new(
        latitude: data_value_json['latitude'],
        longitude: data_value_json['longitude'],
        precision: data_value_json['precision'],
        globe: data_value_json['globe']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      latitude: @latitude,
      longitude: @longitude,
      precision: @precision,
      globe: @globe
    }
  end
end
