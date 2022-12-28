# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The Quantity type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P937",
#     "data-type": "quantity"
#   },
#   "value": {
#     "type": "value",
#     "content": {
#       "amount": "+15",
#       "unit": "1"
#     }
#   }
# }
# ```
class Wikidatum::DataType::Quantity
  # @return [String] A string value like "+2", usually an integer but not always.
  attr_reader :amount

  # @return [String] a URL describing the unit for this quantity, e.g. "meter", "kilometer", "pound", "chapter", "section", etc.
  attr_reader :unit

  # @param amount [String]
  # @param unit [String]
  # @return [void]
  def initialize(amount:, unit:)
    @amount = amount
    @unit = unit
  end

  # @return [Hash]
  def to_h
    {
      amount: @amount,
      unit: @unit
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'quantity'
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataType::Base.new(
      type: :quantity,
      content: new(
        amount: data_value_json['amount'],
        unit: data_value_json['unit']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      amount: @amount,
      unit: @unit
    }
  end
end
