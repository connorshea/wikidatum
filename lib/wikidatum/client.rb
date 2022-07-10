# frozen_string_literal: true

class Wikidatum::Client
  # @return [String] The root URL of the Wikibase instance we want to interact
  #   with. If not provided, will default to Wikidata.
  attr_reader :wikibase_url

  # @return [Boolean] Whether this client instance should identify itself
  #   as a bot when making requests.
  attr_reader :bot

  # @return [String] The UserAgent header to send with all requests to the
  #   Wikibase API.
  attr_reader :user_agent

  # @param wikibase_url [String] The root URL of the Wikibase instance we want
  #   to interact with. If not provided, will default to
  #   `https://www.wikidata.org`. Do not include a `/` at the end of the URL.
  # @param bot [Boolean] Whether requests sent by this client instance should
  #   be registered as bot requests. Defaults to `true`.
  # @param user_agent [String] The UserAgent header to send with all requests
  #   to the Wikibase API.
  # @return [Wikidatum::Client]
  def initialize(wikibase_url: 'https://www.wikidata.org', bot: true, user_agent:)
    raise ArgumentError, "Wikibase URL must not end with a `/`, got '#{wikibase_url}'." if wikibase_url.end_with?('/')

    @wikibase_url = wikibase_url
    @bot = bot
    @user_agent = user_agent
  end

  # Get an item from the Wikibase API based on its QID.
  #
  # @example
  #   wikidatum_client.item(id: 'Q123')
  #   wikidatum_client.item(id: 123)
  #   wikidatum_client.item(id: '123')
  #
  # @param id [String, Integer] Either a string or integer representation of
  #   the item's QID, e.g. `"Q123"`, `"123"`, or `123`.
  # @return [Wikidatum::Item]
  def item(id:)
    raise ArgumentError, "'#{id}' is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'." unless id.is_a?(Integer) || id.match?(/^Q?\d+$/)

    # We need to have the ID in the format "Q123" for the API request, so
    # coerce it if necessary.
    id = "Q#{id}" unless id.start_with?('Q')

    response = request("/entities/items/#{id}")
    # TODO: Do something with this response, presumably we'll want to create an instance of the Item class.
  end

  private

  # For now this just returns the `@wikibase_url`, but in the future the API
  # routes will presumably be nested further, so this is just future-proofing
  # to allow that to be easily changed later.
  #
  # @return [String] URL for the Wikibase API endpoint.
  def api_url
    @api_url ||= @wikibase_url
  end

  # @param path [String] The relative path for the 
  # @return [Hash] JSON response, parsed into a hash.
  def request(path)
    url = "#{api_url}#{path}"

    # TODO: Have this actually send a request and parse the response, and
    # handle errors if necessary.
  end
end
