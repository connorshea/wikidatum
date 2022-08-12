# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Quantity type datavalue JSON looks like this:
#
#  {
#    "datavalue": {
#      "value": {
#        "amount": "+10.38",
#        "upperBound": "+10.375",
#        "lowerBound": "+10.385",
#        "unit": "http://www.wikidata.org/entity/Q712226"
#      },
#      "type": "quantity"
#    }
#  }
class Wikidatum::DataValueType::Quantity
  # @return [String]
  attr_reader :amount

  # @return [String, nil] upper bound, if one is defined.
  attr_reader :upper_bound

  # @return [String, nil] lower bound, if one is defined.
  attr_reader :lower_bound

  # @return [String] a URL describing the unit for this quantity, e.g. "meter", "kilometer", "pound", "chapter", "section", etc.
  attr_reader :unit

  # @!visibility private
  def initialize(amount:, upper_bound:, lower_bound:, unit:)
    @amount = amount
    @upper_bound = upper_bound
    @lower_bound = lower_bound
    @unit = unit
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
end
