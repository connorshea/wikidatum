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

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # statement in the API and turns it into an actual instance of a Statement.
  #
  # @param property_id [String] the property ID for the statement, e.g. 'P123'
  # @param json [Hash]
  # @return [Wikidatum::Statement]
  def self.serialize(property_id, json)
    mainsnak = Wikidatum::Snak.serialize(json['mainsnak'])

    qualifiers = []
    references = []

    Wikidatum::Statement.new(
      id: json['id'],
      property_id: property_id,
      mainsnak: mainsnak,
      qualifiers: qualifiers,
      references: references,
      rank: json['rank']
    )
  end
end
