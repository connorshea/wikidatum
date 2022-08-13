# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Globe Coordinate type datavalue JSON looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": {
#       "latitude": 52.516666666667,
#       "longitude": 13.383333333333,
#       "precision": 0.016666666666667,
#       "globe": "http://www.wikidata.org/entity/Q2"
#     },
#     "type": "globecoordinate"
#   }
# }
# ```
class Wikidatum::DataValueType::GlobeCoordinate
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
    'globecoordinate'
  end

  # The "datatype" value used by Wikibase, usually identical to wikibase_type
  # but not always.
  #
  # @return [String]
  def wikibase_datatype
    'globe-coordinate' # yes, really
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataValueType::Base.new(
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
