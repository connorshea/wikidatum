# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The String type datavalue JSON looks like this:
#
#  {
#    "datavalue": {
#      "value": "Foobar",
#      "type": "string"
#    }
#  }
class Wikidatum::DataValueType::String < Wikidatum::DataValueType::Base
  # @!visibility private
  def self.marshal_load(string)
    new(type: :string, value: string)
  end
end
