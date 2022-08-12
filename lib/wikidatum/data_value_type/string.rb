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
class Wikidatum::DataValueType::String
  # @return [String]
  attr_reader :string

  # @!visibility private
  def initialize(string:)
    @string = string
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
end
