# frozen_string_literal: true

class Wikidatum::Item
  # @param property [String] Wikidata property, in the format of 'P123'. If unspecified, will return all statements for the item.
  # @return [Array<Wikidatum::Statement>]
  def statements(property: nil); end

  # @param language [String, Symbol]
  # @return [Wikidatum::Term]
  def label(language); end

  # @param languages [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def labels(languages = []); end

  # @param language [String, Symbol]
  # @return [Wikidatum::Term]
  def description(language); end

  # @param languages [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def descriptions(languages = []); end

  # @param languages [Array<Symbol, String>] If unspecified, will return all aliases for all languages.
  # @return [Array<Wikidatum::Term>]
  def aliases(languages = []); end

  # @return [Array<Wikidatum::Sitelink>]
  def sitelinks; end
end
