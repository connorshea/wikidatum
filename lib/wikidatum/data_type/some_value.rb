# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The SomeValue type actually has no datavalue key in the blob at all. We work
# around this by just passing nil to the serializer.

# Represents a value of "unknown value".
class Wikidatum::DataType::SomeValue < Wikidatum::DataType::Base
  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'string'
  end

  # @!visibility private
  def self.marshal_load(_data_value_json)
    new(type: :some_value, value: nil)
  end
end
