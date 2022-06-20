# frozen_string_literal: true

# Wikidatum::Sitelinks represent associated sitelinks on a Wikidata item.
class Wikidatum::Sitelink
  # @return [String]
  attr_reader :site

  # @return [String]
  attr_reader :title

  # @return [Array<String>]
  attr_reader :badges

  # @!visibility private
  #
  # @param site [String, Symbol] The shortcode for the given site (e.g. 'enwiki', 'commons', etc.), can be either a string or a symbol.
  # @param title [String] The title of the page in the associated Wikimedia site.
  # @param badges [Array<String>] An array of badge names, optional.
  # @return [Wikidatum::Sitelink]
  def initialize(site:, title:, badges: [])
    @site = site.to_s
    @title = title
    @badges = badges
  end
end
