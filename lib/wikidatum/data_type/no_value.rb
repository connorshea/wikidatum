# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The NoValue type actually has no datavalue key in the blob at all. We work
# around this by just passing nil to the serializer.

# Represents "no value".
class Wikidatum::DataType::NoValue < Wikidatum::DataType::Base
  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'string'
  end

  # @!visibility private
  def self.marshal_load(_data_value_json)
    new(type: :no_value, content: nil)
  end
end
