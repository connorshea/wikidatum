# frozen_string_literal: true

class Wikidatum::Statement
  # @return [String]
  attr_reader :id

  # @return [Wikidatum::Snak]
  attr_accessor :mainsnak

  # @return [Array<Wikidatum::Qualifier>]
  attr_accessor :qualifiers

  # @return [Array<Wikidatum::Reference>]
  attr_accessor :references

  # @return [String]
  attr_accessor :rank

  # @param id [String]
  # @param mainsnak [Wikidatum::Snak]
  # @param qualifiers [Array<Wikidatum::Qualifier>]
  # @param references [Array<Wikidatum::Reference>]
  # @param rank [String] The rank of the given statement.
  #   Can have the values "preferred", "normal", or "deprecated". Defaults to "normal".
  def initialize(id:, mainsnak:, qualifiers:, references:, rank: 'normal')
    @id = id
    @mainsnak = mainsnak
    @qualifiers = qualifiers
    @references = references
    @rank = rank
  end
end
