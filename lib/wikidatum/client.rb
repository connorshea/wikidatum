# frozen_string_literal: true

class Wikidatum::Client
  # @return [String] The root URL of the Wikibase instance we want to interact
  #                  with. If not provided, will default to Wikidata.
  attr_reader :wikibase_url

  # @return [Boolean] Whether this client instance should identify itself
  #                   as a bot when making requests.
  attr_reader :bot

  # @param wikibase_url [String] The root URL of the Wikibase instance we want
  #                              to interact with. If not provided, will
  #                              default to Wikidata.
  # @param bot [Boolean] Whether requests sent by this client instance should
  #                      be registered as bot requests.
  # @return [Wikidatum::Client]
  def initialize(wikibase_url: 'https://www.wikidata.org', bot: true)
    @wikibase_url = wikibase_url
    @bot = bot
  end
end
