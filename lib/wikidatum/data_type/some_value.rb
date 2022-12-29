# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The SomeValue type actually has no datavalue key in the blob at all. We work
# around this by just passing nil to the serializer.

# Represents a value of "unknown value".
class Wikidatum::DataType::SomeValue < Wikidatum::DataType::Base
  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # In this case, the type is a lie.
  #
  # @return [String]
  def wikibase_type
    'string'
  end

  # The content of the data value object. Use this to get a more sensible
  # representation of the statement's contents.
  #
  # @return [nil]
  def humanized
    nil
  end

  # @!visibility private
  def self.marshal_load(_data_value_json)
    new(type: :some_value, content: nil)
  end
end
