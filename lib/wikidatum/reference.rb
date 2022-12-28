# frozen_string_literal: true

class Wikidatum::Reference
  # @return [String] Hash of the reference (a cryptographic hash, not a Ruby hash).
  attr_reader :hash

  # @return [Array<Wikidatum::ReferencePart>]
  attr_reader :parts

  # @!visibility private
  # @param hash [String] Hash of the reference (a cryptographic hash, not a Ruby hash).
  # @param parts [Array<Wikidatum::ReferencePart>]
  def initialize(hash:, parts:)
    @hash = hash
    @parts = parts
  end

  # @return [Hash]
  def to_h
    {
      hash: @hash,
      parts: @parts.map(&:to_h)
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Reference hash=#{@hash.inspect} parts=#{@parts.inspect}>"
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
    parts = ref_json['parts'].map { |part| Wikidatum::ReferencePart.marshal_load(part) }

    Wikidatum::Reference.new(
      hash: ref_json['hash'],
      parts: parts
    )
  end
end
