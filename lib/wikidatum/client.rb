# frozen_string_literal: true

require 'faraday'
require 'faraday/net_http'

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

  # @param user_agent [String] The UserAgent header to send with all requests
  #   to the Wikibase API.
  # @param wikibase_url [String] The root URL of the Wikibase instance we want
  #   to interact with. If not provided, will default to
  #   `https://www.wikidata.org`. Do not include a `/` at the end of the URL.
  # @param bot [Boolean] Whether requests sent by this client instance should
  #   be registered as bot requests. Defaults to `true`.
  # @return [Wikidatum::Client]
  def initialize(user_agent:, wikibase_url: 'https://www.wikidata.org', bot: true)
    raise ArgumentError, "Wikibase URL must not end with a `/`, got '#{wikibase_url}'." if wikibase_url.end_with?('/')

    # TODO: Add the Ruby gem version to the UserAgent automatically, and
    # restrict the ability for end-users to actually set the UserAgent?
    @user_agent = user_agent
    @wikibase_url = wikibase_url
    @bot = bot

    Faraday.default_adapter = :net_http
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
    raise ArgumentError, "#{id.inspect} is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'." unless id.is_a?(Integer) || id.match?(/^Q?\d+$/)

    # We need to have the ID in the format "Q123" for the API request, so
    # coerce it if necessary.
    id = "Q#{id}" unless id.start_with?('Q')

    response = get_request("/entities/items/#{id}")

    puts JSON.pretty_generate(response) if ENV['DEBUG']

    Wikidatum::Item.serialize(response)
  end

  private

  # For now this just returns the `@wikibase_url`, but in the future the API
  # routes will presumably be nested further, so this is just future-proofing
  # to allow that to be easily changed later.
  #
  # @return [String] URL for the Wikibase API endpoint.
  def api_url
    @api_url ||= "#{@wikibase_url}/w/rest.php/wikibase/v0"
  end

  # Default headers to be sent with every request.
  #
  # @return [Hash] A hash of some headers that should be used when sending a request.
  def universal_headers
    @universal_headers ||= {
      'User-Agent' => @user_agent,
      'Content-Type' => 'application/json'
    }
  end

  # Make a GET request to a given Wikibase endpoint.
  #
  # @param path [String] The relative path for the API endpoint.
  # @param params [Hash] Query parameters to send with the request, if any.
  # @return [Hash] JSON response, parsed into a hash.
  def get_request(path, params = nil)
    url = "#{api_url}#{path}"

    response = Faraday.get(url, params, universal_headers)

    # TODO: Error handling if it doesn't return a 200

    JSON.parse(response.body)
  end

  # Make a POST request to a given Wikibase endpoint.
  #
  # @param path [String] The relative path for the API endpoint.
  # @param body [Hash] The body to post to the endpoint.
  # @param tags [Array<String>] The tags to apply to the edit being made by this request, for PUT/POST/DELETE requests.
  # @param comment [String] The edit description, for PUT/POST/DELETE requests.
  # @return [Hash] JSON response, parsed into a hash.
  def post_request(path, body = {}, tags: nil, comment: nil)
    url = "#{api_url}#{path}"

    body[:bot] = @bot
    body[:tags] = tags unless tags.nil?
    body[:comment] = comment unless comment.nil?

    response = Faraday.post(url, body, universal_headers)

    puts response.inspect if ENV['DEBUG']
  end
end
