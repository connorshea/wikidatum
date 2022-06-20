# frozen_string_literal: true

# Wikidatum::Term represents "Terms", which are pairs of language codes and
# values. They're used for things like item labels, descriptions, and aliases.
class Wikidatum::Term
  # @return [String]
  attr_reader :lang

  # @return [String]
  attr_reader :value

  # @param lang [String, Symbol] A language code ('en', 'zh-mo', etc), can be a symbol or a string.
  # @param value [String] The value of the term.
  # @return [Wikidatum::Term]
  def initialize(lang:, value:)
    @lang = lang.to_s
    @value = value
  end
end
