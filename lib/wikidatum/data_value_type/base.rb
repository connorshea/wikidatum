# frozen_string_literal: true

module Wikidatum::DataValueType
  class Base
    attr_reader :type, :value

    # @param type [Symbol]
    # @param value [*]
    def initialize(type:, value:)
      @type = type
      @value = value
    end

    def to_h
      {
        type: @type,
        value: @value
      }
    end

    # @param data_value_type [String] The value of `type` for the given Snak's datavalue.
    # @param data_value_json [Hash] The `value` part of datavalue.
    # @return [] Any of the DataValues subclasses.
    def self.serialize(data_value_type, data_value_json)
      unless Wikidatum::DataValueType::DATA_VALUE_TYPES.keys.include?(data_value_type.to_sym)
        puts 'WARNING: Unsupported datavalue type.'
        return nil
      end

      Object.const_get(Wikidatum::DataValueType::DATA_VALUE_TYPES[data_value_type.to_sym]).serialize(data_value_json)
    end
  end
end
