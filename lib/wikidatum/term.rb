# frozen_string_literal: true

# Wikidatum::Term represents "Terms", which are pairs of language codes and
# values. They're used for things like item labels, descriptions, and aliases.
class Wikidatum::Term
  # @return [String] A language code ('en', 'zh-mo', etc).
  attr_reader :lang

  # @return [String] The value of the Term.
  attr_reader :value

  # @!visibility private
  #
  # @param lang [String, Symbol] A language code ('en', 'zh-mo', etc), can be a symbol or a string.
  # @param value [String] The value of the Term.
  # @return [Wikidatum::Term]
  def initialize(lang:, value:)
    @lang = lang.to_s
    @value = value
  end

  # @return [Hash]
  def to_h
    {
      lang: @lang,
      value: @value
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Term lang=#{@lang.inspect} value=#{@value.inspect}>"
  end
end
