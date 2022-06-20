# frozen_string_literal: true

class Wikidatum::Item
  # @param labels [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing labels for this item.
  # @param descriptions [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing descriptions for this item.
  # @param aliases [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing aliases for this item.
  # @param statements [Array<Wikidatum::Statement>] Statements for this item.
  # @param sitelinks [Array<Wikidatum::Sitelink>] Sitelinks for this item.
  # @return [Wikidatum::Item]
  def initialize(labels:, descriptions:, aliases:, statements:, sitelinks:)
    @labels = labels
    @descriptions = descriptions
    @aliases = aliases
    @statements = statements
    @sitelinks = sitelinks
  end

  # @param property [String] Wikidata property, in the format of 'P123'. If unspecified, will return all statements for the item.
  # @return [Array<Wikidatum::Statement>]
  def statements(property: nil); end

  # @param lang [String, Symbol]
  # @return [Wikidatum::Term, nil]
  def label(lang:)
    @labels.find { |label| label.lang == lang.to_s }
  end

  # @param langs [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def labels(langs: [])
    return @labels if langs.empty?

    langs.map!(&:to_s)
    @labels.filter { |label| langs.include?(label.lang) }
  end

  # @param lang [String, Symbol]
  # @return [Wikidatum::Term, nil]
  def description(lang:)
    @descriptions.find { |desc| desc.lang == lang.to_s }
  end

  # @param langs [Array<String, Symbol>]
  # @return [Array<Wikidatum::Term>]
  def descriptions(langs: [])
    return @descriptions if langs.empty?

    langs.map!(&:to_s)
    @descriptions.filter { |desc| langs.include?(desc.lang) }
  end

  # @param langs [Array<Symbol, String>] If unspecified, will return all aliases for all languages.
  # @return [Array<Wikidatum::Term>]
  def aliases(langs: [])
    return @aliases if langs.empty?

    langs.map!(&:to_s)
    @aliases.filter { |al| langs.include?(al.lang) }
  end

  # Get a specific sitelink based on its shortcode.
  #
  # @example
  #   item.sitelink(site: 'enwiki')
  # @example Using a symbol key
  #   item.sitelink(site: :enwiki)
  #
  # @param site [String, Symbol] The shortcode for the sitelink you want to access, e.g. 'enwiki' or 'commons'. Can be a string or a symbol.
  # @return [Wikidatum::Sitelink, nil]
  def sitelink(site:)
    @sitelinks.find { |sitelink| sitelink.site == site.to_s }
  end

  # Get the sitelinks on the item.
  #
  # @example Getting all sitelinks for the item.
  #   item.sitelinks
  # @example Getting only a few specific sitelinks.
  #   item.sitelink(sites: ['enwiki', 'eswiki', 'commons'])
  #
  # @param sites [Array<String, Symbol>] An array of sitelink shortcodes to return (e.g. ['enwiki', 'eswiki']), if not provided then all sitelinks will be returned.
  # @return [Array<Wikidatum::Sitelink>]
  def sitelinks(sites: [])
    return @sitelinks if sites.empty?

    sites.map!(&:to_s)
    @sitelinks.filter { |sitelink| sites.include?(sitelink.site) }
  end
end
