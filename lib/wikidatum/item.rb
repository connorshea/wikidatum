# frozen_string_literal: true

class Wikidatum::Item
  # @param property [String] Wikidata property, in the format of 'P123'. If unspecified, will return all statements for the item.
  # @return [Array<Wikidatum::Statement>]
  def statements(property: nil); end

  # @param lang [String, Symbol]
  # @return [Wikidatum::Term]
  def label(lang); end

  # @param langs [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def labels(langs = []); end

  # @param lang [String, Symbol]
  # @return [Wikidatum::Term]
  def description(lang); end

  # @param langs [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def descriptions(langs = []); end

  # @param langs [Array<Symbol, String>] If unspecified, will return all aliases for all languages.
  # @return [Array<Wikidatum::Term>]
  def aliases(langs = []); end

  # @return [Array<Wikidatum::Sitelink>]
  def sitelinks; end
end
