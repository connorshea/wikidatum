# frozen_string_literal: true

class Wikidatum::Item
  # @return [String] The ID of the Wikibase item, in the format "Q123".
  attr_reader :id

  # @!visibility private
  #
  # @param id [String] The ID of the Wikibase item, in the format "Q123".
  # @param labels [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing labels for this item.
  # @param descriptions [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing descriptions for this item.
  # @param aliases [Array<Wikidatum::Term>] An array of {Wikidatum::Term}s representing aliases for this item.
  # @param statements [Array<Wikidatum::Statement>] Statements for this item.
  # @param sitelinks [Array<Wikidatum::Sitelink>] Sitelinks for this item.
  # @return [Wikidatum::Item]
  def initialize(id:, labels:, descriptions:, aliases:, statements:, sitelinks:)
    @id = id
    @labels = labels
    @descriptions = descriptions
    @aliases = aliases
    @statements = statements
    @sitelinks = sitelinks
  end

  # @param property [String] Wikidata property, in the format of 'P123'. If unspecified, will return all statements for the item.
  # @return [Array<Wikidatum::Statement>]
  def statements(property: nil)
    return @statements if property.nil?

    @statements.filter { |statement| statement.property_id == property }
  end

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
  #   item.sitelinks(sites: ['enwiki', 'eswiki', 'commons'])
  #
  # @param sites [Array<String, Symbol>] An array of sitelink shortcodes to return (e.g. ['enwiki', 'eswiki']), if not provided then all sitelinks will be returned.
  # @return [Array<Wikidatum::Sitelink>]
  def sitelinks(sites: [])
    return @sitelinks if sites.empty?

    sites.map!(&:to_s)
    @sitelinks.filter { |sitelink| sites.include?(sitelink.site) }
  end

  # @return [Hash]
  def to_h
    {
      id: @id,
      labels: @labels.map(&:to_h),
      descriptions: @descriptions.map(&:to_h),
      aliases: @aliases.map(&:to_h),
      statements: @statements.map(&:to_h),
      sitelinks: @sitelinks.map(&:to_h)
    }
  end

  # @!visibility private
  #
  # This takes in the JSON blob (as a hash) that is output for an item record
  # in the API and turns it into an actual instance of an Item.
  #
  # @param item_json [Hash]
  # @return [Wikidatum::Item]
  def self.serialize(item_json)
    labels = item_json['labels'].to_a.map { |lang, label| Wikidatum::Term.new(lang: lang, value: label) }
    descriptions = item_json['descriptions'].to_a.map { |lang, desc| Wikidatum::Term.new(lang: lang, value: desc) }
    aliases = item_json['aliases'].to_a.flat_map do |lang, als|
      als.map { |al| Wikidatum::Term.new(lang: lang, value: al) }
    end
    statements = item_json['statements'].to_a.flat_map do |property_id, st_arr|
      st_arr.map { |statement| Wikidatum::Statement.serialize(property_id, statement) }
    end
    sitelinks = item_json['sitelinks'].to_a.map do |_name, sitelink|
      Wikidatum::Sitelink.new(site: sitelink['site'], title: sitelink['title'], badges: sitelink['badges'])
    end

    Wikidatum::Item.new(
      id: item_json['id'],
      labels: labels,
      descriptions: descriptions,
      aliases: aliases,
      statements: statements,
      sitelinks: sitelinks
    )
  end
end
