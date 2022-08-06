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
      lang: @hash,
      value: @snaks
    }
  end
end
