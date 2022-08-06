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

  # @return [Hash]
  def to_h
    {
      hash: @hash,
      snaktype: @snaktype,
      property: @property,
      datatype: @datatype,
      datavalue: @datavalue
    }
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # snak in the API and turns it into an actual instance of a Snak.
  #
  # @param snak_json [Hash]
  # @return [Wikidatum::Snak]
  def self.serialize(snak_json)
    puts 'snak_json'
    puts snak_json.inspect
    puts 'snaktype'
    puts snak_json['snaktype'].inspect
    datavalue = Wikidatum::DataValueType::Base.serialize('novalue', nil) if snak_json['snaktype'] == 'novalue'
    datavalue ||= Wikidatum::DataValueType::Base.serialize(snak_json['datavalue']['type'], snak_json['datavalue']['value'])

    Wikidatum::Snak.new(
      hash: snak_json['hash'],
      snaktype: snak_json['snaktype'],
      property: snak_json['property'],
      datatype: snak_json['datatype'],
      datavalue: datavalue
    )
  end
end
