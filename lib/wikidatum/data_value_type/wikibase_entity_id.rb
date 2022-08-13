# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Wikibase Entity ID type datavalue JSON looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": {
#       "entity-type": "item",
#       "numeric-id": 552863,
#       "id": "Q552863"
#     },
#     "type": "wikibase-entityid"
#   }
# }
# ```
class Wikidatum::DataValueType::WikibaseEntityId
  # @return [String] usually "item"
  attr_reader :entity_type

  # @return [Integer] the integer representation of the Wikibase ID.
  attr_reader :numeric_id

  # @return [String] in the format "Q123".
  attr_reader :id

  # @param entity_type [String]
  # @param numeric_id [Integer]
  # @param id [String]
  # @return [void]
  def initialize(entity_type:, numeric_id:, id:)
    @entity_type = entity_type
    @numeric_id = numeric_id
    @id = id
  end

  # @return [Hash]
  def to_h
    {
      entity_type: @entity_type,
      numeric_id: @numeric_id,
      id: @id
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'wikibase-entityid'
  end

  # The "datatype" value used by Wikibase, usually identical to wikibase_type
  # but not always.
  #
  # @return [String]
  def wikibase_datatype
    'wikibase-item' # yes, really
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataValueType::Base.new(
      type: :wikibase_entity_id,
      value: new(
        entity_type: data_value_json['entity-type'],
        numeric_id: data_value_json['numeric-id'],
        id: data_value_json['id']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      'entity-type': @entity_type,
      'numeric-id': @numeric_id,
      id: @id
    }
  end
end
