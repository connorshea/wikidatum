# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The NoValue type actually has no datavalue key in the blob at all. We work
# around this by just passing nil to the serializer.

# Represents "no value".
class Wikidatum::DataValueType::NoValue < Wikidatum::DataValueType::Base
  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'string'
  end

  # The "datatype" value used by Wikibase, usually identical to wikibase_type
  # but not always.
  #
  # @return [String]
  def wikibase_datatype
    wikibase_type
  end

  # @!visibility private
  def self.marshal_load(_data_value_json)
    new(type: :no_value, value: nil)
  end
end
