# frozen_string_literal: true

# Wikidatum::Sitelinks represent associated sitelinks on a Wikidata item, for
# example the associated English Wikipedia article.
class Wikidatum::Sitelink
  # @return [String] The shortcode for the given site (e.g. 'enwiki', 'commons', etc.).
  attr_reader :site

  # @return [String] The title of the page in the associated Wikimedia site.
  attr_reader :title

  # @return [Array<String>] An array of badges, given as item IDs (e.g. `['Q123', 'Q124']`).
  attr_reader :badges

  # @!visibility private
  #
  # @param site [String, Symbol] The shortcode for the given site (e.g. 'enwiki', 'commons', etc.), can be either a string or a symbol.
  # @param title [String] The title of the page in the associated Wikimedia site.
  # @param badges [Array<String>] An array of badges, given as item IDs (e.g. `['Q123', 'Q124']`). This parameter is optional.
  # @return [Wikidatum::Sitelink]
  def initialize(site:, title:, badges: [])
    @site = site.to_s
    @title = title
    @badges = badges
  end

  # @return [Hash]
  def to_h
    {
      site: @site,
      title: @title,
      badges: @badges
    }
  end

  # @return [String]
  def inspect
    "<Wikidatum::Sitelink site=#{@site.inspect} title=#{@title.inspect} badges=#{@badges.inspect}>"
  end
end
