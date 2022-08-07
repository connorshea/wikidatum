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
class Wikidatum::DataValueType::Quantity < Wikidatum::DataValueType::Base
  # @!visibility private
  def self.marshal_load(data_value_json)
    new(
      type: :quantity,
      value: {
        amount: data_value_json['amount'],
        upper_bound: data_value_json['upperBound'],
        lower_bound: data_value_json['lowerBound'],
        unit: data_value_json['unit']
      }
    )
  end
end
