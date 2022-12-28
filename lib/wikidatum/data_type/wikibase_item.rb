# frozen_string_literal: true

require 'wikidatum/data_type/base'

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
class Wikidatum::DataType::WikibaseItem
  # @return [String] in the format "Q123".
  attr_reader :id

  # @param id [String]
  # @return [void]
  def initialize(id:)
    @id = id
  end

  # @return [Hash]
  def to_h
    {
      id: @id
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'wikibase-item'
  end

  # @return [Symbol]
  def self.symbolized_name
    :wikibase_item
  end

  # @!visibility private
  def self.marshal_load(id)
    Wikidatum::DataType::Base.new(
      type: symbolized_name,
      content: new(
        id: id
      )
    )
  end

  # @!visibility private
  def marshal_dump
    @id
  end
end
