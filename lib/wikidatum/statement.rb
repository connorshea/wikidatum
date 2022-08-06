# frozen_string_literal: true

class Wikidatum::Statement
  # @return [String]
  attr_reader :id

  # @return [String]
  attr_accessor :property_id

  # @return [Wikidatum::Snak]
  attr_accessor :mainsnak

  # @return [Array<Wikidatum::Qualifier>]
  attr_accessor :qualifiers

  # @return [Array<Wikidatum::Reference>]
  attr_accessor :references

  # @return [String]
  attr_accessor :rank

  # @param id [String]
  # @param property_id [String] The 'P123' ID of the property that this statement represents.
  # @param mainsnak [Wikidatum::Snak]
  # @param qualifiers [Array<Wikidatum::Qualifier>]
  # @param references [Array<Wikidatum::Reference>]
  # @param rank [String] The rank of the given statement.
  #   Can have the values "preferred", "normal", or "deprecated". Defaults to "normal".
  def initialize(id:, property_id:, mainsnak:, qualifiers:, references:, rank: 'normal')
    @id = id
    @property_id = property_id
    @mainsnak = mainsnak
    @qualifiers = qualifiers
    @references = references
    @rank = rank
  end

  # @return [Hash]
  def to_h
    {
      id: @id,
      property_id: @property_id,
      mainsnak: @mainsnak.to_h,
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
  # @param property_id [String] the property ID for the statement, e.g. 'P123'
  # @param statement_json [Hash]
  # @return [Wikidatum::Statement]
  def self.serialize(property_id, statement_json)
    mainsnak = Wikidatum::Snak.serialize(statement_json['mainsnak'])

    qualifiers = statement_json['qualifiers'].to_a.flat_map do |_qualifier_prop_id, qualifier|
      qualifier.map { |q| Wikidatum::Qualifier.serialize(q) }
    end
    references = statement_json['references'].flat_map do |reference|
      Wikidatum::Reference.serialize(reference)
    end

    Wikidatum::Statement.new(
      id: statement_json['id'],
      property_id: property_id,
      mainsnak: mainsnak,
      qualifiers: qualifiers,
      references: references,
      rank: statement_json['rank']
    )
  end
end
