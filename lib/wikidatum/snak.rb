# frozen_string_literal: true

class Wikidatum::Snak
  # @return [String] Hash of a snak (a cryptographic hash, not a Ruby hash).
  attr_reader :hash

  # @return [String]
  attr_reader :snaktype

  # @return [String] ID of the property for this Snak, in the format 'P123'.
  attr_reader :property

  # @return [String]
  attr_reader :datatype

  # For more information on the possible types that can be returned by
  # datavalues, see the official documentation:
  # https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html#json_datavalues
  #
  # @return [Wikidatum::DataValueType::Base] the value of the statement, can take various forms
  attr_reader :datavalue

  # @!visibility private
  # @param hash [String] Hash of a snak (a cryptographic hash, not a Ruby hash).
  # @param snaktype [String]
  # @param property [String] ID of the property for this Snak, in the format 'P123'.
  # @param datatype [String]
  # @param datavalue [DataValueType::GlobeCoordinate, DataValueType::MonolingualText, DataValueType::Quantity, DataValueType::WikibaseString, DataValueType::Time, DataValueType::WikibaseItem]
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
      datavalue: @datavalue.to_h
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Snak hash=#{@hash.inspect} snaktype=#{@snaktype.inspect} property=#{@property.inspect} datatype=#{@datatype.inspect} datavalue=#{@datavalue.inspect}>"
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # snak in the API and turns it into an actual instance of a Snak.
  #
  # @param snak_json [Hash]
  # @return [Wikidatum::Snak]
  def self.marshal_load(snak_json)
    # snaktype can be 'novalue' (no value) or 'somevalue' (unknown), so we handle those as somewhat special cases
    case snak_json['snaktype']
    when 'novalue'
      datavalue = Wikidatum::DataValueType::Base.marshal_load('novalue', nil)
    when 'somevalue'
      datavalue = Wikidatum::DataValueType::Base.marshal_load('somevalue', nil)
    when 'value'
      datavalue = Wikidatum::DataValueType::Base.marshal_load(snak_json['datavalue']['type'], snak_json['datavalue']['value'])
    end

    Wikidatum::Snak.new(
      hash: snak_json['hash'],
      snaktype: snak_json['snaktype'],
      property: snak_json['property'],
      datatype: snak_json['datatype'],
      datavalue: datavalue
    )
  end
end
