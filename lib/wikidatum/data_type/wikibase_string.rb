# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The String type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P143",
#     "data-type": "string"
#   },
#   "value": {
#     "type": "value",
#     "content": "foo"
#   }
# }
# ```
class Wikidatum::DataType::WikibaseString
  # @return [String] the value for the string.
  attr_reader :string

  # @param string [String]
  # @return [void]
  def initialize(string:)
    @string = string
  end

  # @return [Hash]
  def to_h
    {
      string: @string
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'string'
  end

  # The content of the data value object. Use this to get a more sensible
  # representation of the statement's contents.
  #
  # @return [String]
  def humanized
    @string
  end

  # @return [Symbol]
  def self.symbolized_name
    :string
  end

  # @!visibility private
  def self.marshal_load(string)
    Wikidatum::DataType::Base.new(
      type: symbolized_name,
      content: new(
        string: string
      )
    )
  end

  # @!visibility private
  def marshal_dump
    @string
  end
end
