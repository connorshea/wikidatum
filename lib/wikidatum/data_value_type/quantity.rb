# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Quantity type datavalue JSON looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": {
#       "amount": "+10.38",
#       "upperBound": "+10.375",
#       "lowerBound": "+10.385",
#       "unit": "http://www.wikidata.org/entity/Q712226"
#     },
#     "type": "quantity"
#   }
# }
# ```
class Wikidatum::DataValueType::Quantity
  # @return [String] A string value like "+2", usually an integer but not always.
  attr_reader :amount

  # @return [String, nil] upper bound, if one is defined.
  attr_reader :upper_bound

  # @return [String, nil] lower bound, if one is defined.
  attr_reader :lower_bound

  # @return [String] a URL describing the unit for this quantity, e.g. "meter", "kilometer", "pound", "chapter", "section", etc.
  attr_reader :unit

  # @param amount [String]
  # @param upper_bound [String]
  # @param lower_bound [String]
  # @param unit [String]
  # @return [void]
  def initialize(amount:, upper_bound:, lower_bound:, unit:)
    @amount = amount
    @upper_bound = upper_bound
    @lower_bound = lower_bound
    @unit = unit
  end

  # @return [Hash]
  def to_h
    {
      amount: @amount,
      upper_bound: @upper_bound,
      lower_bound: @lower_bound,
      unit: @unit
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'quantity'
  end

  # The "datatype" value used by Wikibase, usually identical to wikibase_type
  # but not always.
  #
  # @return [String]
  def wikibase_datatype
    wikibase_type
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataValueType::Base.new(
      type: :quantity,
      value: new(
        amount: data_value_json['amount'],
        upper_bound: data_value_json['upperBound'],
        lower_bound: data_value_json['lowerBound'],
        unit: data_value_json['unit']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      amount: @amount,
      upperBound: @upper_bound,
      lowerBound: @lower_bound,
      unit: @unit
    }
  end
end
