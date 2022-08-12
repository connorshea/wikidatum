# frozen_string_literal: true

# For more information on the possible types that can be returned by
# datavalues, see the official documentation:
# https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_datavalues
module Wikidatum::DataValueType
  class Base
    # Represents the type for this datavalue instance.
    #
    # Possible values for the `type` attribute are:
    #
    # - `:no_value`: No value
    # - `:some_value`: Unknown value
    # - `:globe_coordinate`: {DataValueType::GlobeCoordinate}
    # - `:monolingual_text`: {DataValueType::MonolingualText}
    # - `:quantity`: {DataValueType::Quantity}
    # - `:string`: {DataValueType::String}
    # - `:time`: {DataValueType::Time}
    # - `:wikibase_entity_id`: {DataValueType::WikibaseEntityId}
    #
    # @return [Symbol]
    attr_reader :type

    # The value of the datavalue object in the response.
    #
    # If the `type` is `novalue` or `somevalue`, this returns `nil`.
    #
    # @return [DataValueType::GlobeCoordinate, DataValueType::MonolingualText, DataValueType::Quantity, DataValueType::String, DataValueType::Time, DataValueType::WikibaseEntityId, nil]
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
        value: @value&.to_h
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
