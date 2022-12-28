# frozen_string_literal: true

class Wikidatum::Qualifier
  # @return [String] ID of the property for this Qualifier, in the format 'P123'.
  attr_reader :property_id

  # @return [String]
  attr_reader :data_type

  # For more information on the possible types that can be returned by
  # datavalues, see the official documentation:
  # https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_datavalues
  #
  # @return [Wikidatum::DataType::Base] the value of the statement, can take various forms
  attr_reader :value

  # @!visibility private
  # @param property_id [String] ID of the property for this Qualifier, in the format 'P123'.
  # @param data_type [String]
  # @param value [DataType::GlobeCoordinate, DataType::MonolingualText, DataType::Quantity, DataType::WikibaseString, DataType::Time, DataType::WikibaseItem, DataType::NoValue, DataType::SomeValue]
  def initialize(property_id:, data_type:, value:)
    @property_id = property_id
    @data_type = data_type
    @value = value
  end

  # @return [Hash]
  def to_h
    {
      property_id: @property_id,
      data_type: @data_type,
      value: @value.to_h
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Qualifier property_id=#{@property_id.inspect} data_type=#{@data_type.inspect} value=#{@value.inspect}>"
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # qualifier the API and turns it into an actual instance of a Qualifier.
  #
  # @param qualifier_json [Hash]
  # @return [Wikidatum::Qualifier]
  def self.marshal_load(qualifier_json)
    Wikidatum::Qualifier.new(
      property_id: qualifier_json.dig('property', 'id'),
      data_type: qualifier_json.dig('property', 'data-type'),
      value: data_value(qualifier_json)
    )
  end

  private

  def self.data_value(qualifier_json)
    # the type can be 'novalue' (no value) or 'somevalue' (unknown), so we handle those as somewhat special cases
    case qualifier_json['value']['type']
    when 'novalue'
      Wikidatum::DataType::Base.marshal_load('novalue', nil)
    when 'somevalue'
      Wikidatum::DataType::Base.marshal_load('somevalue', nil)
    when 'value'
      Wikidatum::DataType::Base.marshal_load(qualifier_json['property']['data-type'], qualifier_json['value']['content'])
    end
  end
end
