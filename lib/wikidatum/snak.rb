# frozen_string_literal: true

class Wikidatum::Snak
  # @return [String] Hash of a snak (a cryptographic hash, not a Ruby hash).
  attr_reader :hash

  # @param snaktype [String]
  attr_reader :snaktype

  # @param property [String] ID of the property for this Snak, in the format 'P123'.
  attr_reader :property

  # @param datatype [String]
  attr_reader :datatype

  # @param datavalue [?] TODO: Not 100% sure what shape this will take yet.
  attr_reader :datavalue

  # @!visibility private
  # @param hash [String] Hash of a snak (a cryptographic hash, not a Ruby hash).
  # @param snaktype [String]
  # @param property [String] ID of the property for this Snak, in the format 'P123'.
  # @param datatype [String]
  # @param datavalue [?] TODO: Not sure what this is yet.
  def initialize(hash:, snaktype:, property:, datatype:, datavalue:)
    @hash = hash
    @snaktype = snaktype
    @property = property
    @datatype = datatype
    @datavalue = datavalue
  end
end
