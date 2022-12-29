# frozen_string_literal: true

class Wikidatum::Statement
  # @return [String]
  attr_reader :id

  # @return [String] property ID, in the format of 'P123'.
  attr_accessor :property_id

  # @return [String]
  attr_accessor :data_type

  # @return [DataType::CommonsMedia, DataType::ExternalId, DataType::GlobeCoordinate, DataType::MonolingualText, DataType::Quantity, DataType::Time, DataType::WikibaseItem, DataType::WikibaseString, DataType::WikibaseUrl, nil]
  attr_accessor :data_value

  # @return [Array<Wikidatum::Qualifier>]
  attr_accessor :qualifiers

  # @return [Array<Wikidatum::Reference>]
  attr_accessor :references

  # @return [String] the rank of the given statement.
  #   Can have the values "preferred", "normal", or "deprecated". Defaults to "normal".
  attr_accessor :rank

  # @param id [String]
  # @param property_id [String] The 'P123' ID of the property that this statement represents.
  # @param data_type [String]
  # @param data_value [DataType::CommonsMedia, DataType::ExternalId, DataType::GlobeCoordinate, DataType::MonolingualText, DataType::Quantity, DataType::Time, DataType::WikibaseItem, DataType::WikibaseString, DataType::WikibaseUrl, nil]
  # @param qualifiers [Array<Wikidatum::Qualifier>]
  # @param references [Array<Wikidatum::Reference>]
  # @param rank [String] The rank of the given statement.
  #   Can have the values "preferred", "normal", or "deprecated". Defaults to "normal".
  def initialize(id:, property_id:, data_type:, data_value:, qualifiers:, references:, rank: 'normal')
    @id = id
    @property_id = property_id
    @data_type = data_type
    @data_value = data_value
    @qualifiers = qualifiers
    @references = references
    @rank = rank
  end

  # @return [Hash]
  def to_h
    {
      id: @id,
      property_id: @property_id,
      data_type: @data_type,
      data_value: @data_value.to_h,
      qualifiers: @qualifiers.map(&:to_h),
      references: @references.map(&:to_h),
      rank: @rank
    }
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # statement in the API and turns it into an actual instance of a Statement.
  #
  # @param statement_json [Hash]
  # @return [Wikidatum::Statement]
  def self.marshal_load(statement_json)
    data_type = Wikidatum::Utils.symbolized_name_for_data_type(statement_json['property']['data-type'])
    data_value = Wikidatum::Utils.ingest_snak(statement_json)

    property_id = statement_json['property']['id']

    qualifiers = statement_json['qualifiers'].to_a.flat_map do |qualifier|
      Wikidatum::Qualifier.marshal_load(qualifier)
    end
    references = statement_json['references'].flat_map do |reference|
      Wikidatum::Reference.marshal_load(reference)
    end

    Wikidatum::Statement.new(
      id: statement_json['id'],
      property_id: property_id,
      data_type: data_type,
      data_value: data_value,
      qualifiers: qualifiers,
      references: references,
      rank: statement_json['rank']
    )
  end
end
