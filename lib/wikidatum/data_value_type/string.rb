# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The String type datavalue JSON looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": "Foobar",
#     "type": "string"
#   }
# }
# ```
class Wikidatum::DataValueType::String
  # @return [String] the value for the string.
  attr_reader :string

  # @!visibility private
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

  # @!visibility private
  def self.marshal_load(string)
    Wikidatum::DataValueType::Base.new(
      type: :string,
      value: new(
        string: string
      )
    )
  end

  # @!visibility private
  def marshal_dump
    @string
  end
end
