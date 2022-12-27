# frozen_string_literal: true

class Wikidatum::Reference
  # @return [String] Hash of the reference (a cryptographic hash, not a Ruby hash).
  attr_reader :hash

  # @return [Array<Wikidatum::Snak>]
  attr_reader :snaks

  # @!visibility private
  # @param hash [String] Hash of the reference (a cryptographic hash, not a Ruby hash).
  # @param snaks [Array<Wikidatum::Snak>]
  def initialize(hash:, snaks:)
    @hash = hash
    @snaks = snaks
  end

  # @return [Hash]
  def to_h
    {
      hash: @hash,
      snaks: @snaks.map(&:to_h)
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Reference hash=#{@hash.inspect} snaks=#{@snaks.inspect}>"
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for a given
  # reference in the API and turns it into an actual instance of a
  # Reference.
  #
  # @param ref_json [Hash]
  # @return [Wikidatum::Reference]
  def self.marshal_load(ref_json)
    # TODO: Actually fix this.
    return nil
    snaks = ref_json['snaks'].values.flatten.map { |snak| Wikidatum::Snak.marshal_load(snak) }

    Wikidatum::Reference.new(
      hash: ref_json['hash'],
      snaks: snaks
    )
  end
end
