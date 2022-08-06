# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The SomeValue type actually has no datavalue key in the blob at all. We work
# around this by just passing nil to the serializer.
class Wikidatum::DataValueType::SomeValue < Wikidatum::DataValueType::Base
  def self.serialize(_data_value_json)
    new(type: :some_value, value: nil)
  end
end
