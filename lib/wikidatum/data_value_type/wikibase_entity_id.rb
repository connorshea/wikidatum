# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Wikibase Entity ID type datavalue JSON looks like this:
#
#  {
#    "datavalue": {
#      "value": {
#        "entity-type": "item",
#        "numeric-id": 552863,
#        "id": "Q552863"
#      },
#      "type": "wikibase-entityid"
#    }
#  }
class Wikidatum::DataValueType::WikibaseEntityId < Wikidatum::DataValueType::Base
  # @!visibility private
  def self.serialize(data_value_json)
    new(
      type: :wikibase_entity_id,
      value: {
        entity_type: data_value_json['entity-type'],
        numeric_id: data_value_json['numeric-id'],
        id: data_value_json['id']
      }
    )
  end
end
