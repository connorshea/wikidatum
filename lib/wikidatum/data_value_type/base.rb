# frozen_string_literal: true

module Wikidatum::DataValueType
  class Base
    # @return [Symbol]
    attr_reader :type

    attr_reader :value

    # @!visibility private
    #
    # @param type [Symbol]
    # @param value [DataValueType::GlobeCoordinate, DataValueType::MonolingualText, DataValueType::Quantity, DataValueType::String, DataValueType::Time, DataValueType::WikibaseEntityId, nil]
    def initialize(type:, value:)
      @type = type
      @value = value
    end

    # @return [Hash]
    def to_h
      {
        type: @type,
        value: @value
      }
    end

    # @!visibility private
    #
    # @param data_value_type [String] The value of `type` for the given Snak's datavalue.
    # @param data_value_json [Hash] The `value` part of datavalue.
    # @return [Wikidatum::DataValueType::Base] An instance of Base.
    def self.marshal_load(data_value_type, data_value_json)
      unless Wikidatum::DataValueType::DATA_VALUE_TYPES.keys.include?(data_value_type.to_sym)
        puts 'WARNING: Unsupported datavalue type.'
        return nil
      end

      Object.const_get(Wikidatum::DataValueType::DATA_VALUE_TYPES[data_value_type.to_sym]).marshal_load(data_value_json)
    end
  end
end
