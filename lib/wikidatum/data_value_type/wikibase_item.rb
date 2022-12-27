# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Wikibase Item type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P963",
#     "data-type": "wikibase-item"
#   },
#   "value": {
#     "type": "value",
#     "content": "Q524026"
#   }
# }
# ```
class Wikidatum::DataValueType::WikibaseItem
  # @return [String] in the format "Q123".
  attr_reader :wikibase_id

  # @param wikibase_id [String]
  # @return [void]
  def initialize(wikibase_id:)
    @wikibase_id = wikibase_id
  end

  # @return [Hash]
  def to_h
    {
      wikibase_id: @wikibase_id
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'wikibase-item'
  end

  # @!visibility private
  def self.marshal_load(wikibase_id)
    Wikidatum::DataValueType::Base.new(
      type: :wikibase_item,
      value: new(
        wikibase_id: wikibase_id
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      wikibase_id: @wikibase_id
    }
  end
end
