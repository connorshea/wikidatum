# frozen_string_literal: true

require 'faraday'
require 'faraday/net_http'

class Wikidatum::Client
  ITEM_REGEX = /^Q?\d+$/.freeze
  STATEMENT_REGEX = /^Q?\d+\$[\w-]+$/.freeze

  # @return [String] the root URL of the Wikibase instance we want to interact
  #   with. If not provided, will default to Wikidata.
  attr_reader :wikibase_url

  # @return [Boolean] whether this client instance should identify itself
  #   as a bot when making requests.
  attr_reader :bot

  # @return [String] the UserAgent header to send with all requests to the
  #   Wikibase API.
  attr_reader :user_agent

  # Create a new Wikidatum::Client to interact with the Wikibase REST API.
  #
  # @example
  #  wikidatum_client = Wikidatum::Client.new(
  #    user_agent: 'REPLACE ME WITH THE NAME OF YOUR BOT!',
  #    wikibase_url: 'https://www.wikidata.org',
  #    bot: true
  #  )
  #
  # @param user_agent [String] The UserAgent header to send with all requests
  #   to the Wikibase API.
  # @param wikibase_url [String] The root URL of the Wikibase instance we want
  #   to interact with. If not provided, will default to
  #   `https://www.wikidata.org`. Do not include a `/` at the end of the URL.
  # @param bot [Boolean] Whether requests sent by this client instance should
  #   be registered as bot requests. Defaults to `true`.
  # @return [Wikidatum::Client]
  def initialize(user_agent:, wikibase_url: 'https://www.wikidata.org', bot: true)
    raise ArgumentError, "Wikibase URL must not end with a `/`, got #{wikibase_url.inspect}." if wikibase_url.end_with?('/')

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
    raise ArgumentError, "#{id.inspect} is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'." unless id.is_a?(Integer) || id.match?(ITEM_REGEX)

    id = coerce_item_id(id)

    response = get_request("/entities/items/#{id}")

    puts JSON.pretty_generate(response) if ENV['DEBUG']

    Wikidatum::Item.marshal_load(response)
  end

  # Get a statement from the Wikibase API based on its ID.
  #
  # @example
  #   wikidatum_client.statement(id: 'Q123$f004ec2b-4857-3b69-b370-e8124f5bd3ac')
  #
  # @param id [String] A string representation of the statement's ID.
  # @return [Wikidatum::Statement]
  def statement(id:)
    raise ArgumentError, "#{id.inspect} is an invalid Wikibase Statement ID. Must be a string in the format 'Q123$f004ec2b-4857-3b69-b370-e8124f5bd3ac'." unless id.match?(STATEMENT_REGEX)

    response = get_request("/statements/#{id}")

    puts JSON.pretty_generate(response) if ENV['DEBUG']

    Wikidatum::Statement.marshal_load(response)
  end

  # Add a statement to an item.
  #
  # NOTE: Adding references/qualifiers with `add_statement` is untested and
  # effectively unsupported for now.
  #
  # @example Add a string statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P23',
  #     datavalue: Wikidatum::DataValueType::WikibaseString.new(string: 'Foo'),
  #     comment: 'Adding something or another.'
  #   )
  #
  # @example Add a 'no value' statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::NoValue.new(
  #       type: :no_value,
  #       value: nil
  #     )
  #   )
  #
  # @example Add an 'unknown value' statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::SomeValue.new(
  #       type: :some_value,
  #       value: nil
  #     )
  #   )
  #
  # @example Add a globe coordinate statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::GlobeCoordinate.new(
  #       latitude: 52.51666,
  #       longitude: 13.3833,
  #       precision: 0.01666,
  #       globe: 'https://wikidata.org/entity/Q2'
  #     )
  #   )
  #
  # @example Add a monolingual text statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::MonolingualText.new(
  #       language: 'en',
  #       text: 'Foobar'
  #     )
  #   )
  #
  # @example Add a quantity statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::Quantity.new(
  #       amount: '+12',
  #       upper_bound: nil,
  #       lower_bound: nil,
  #       unit: 'https://wikidata.org/entity/Q1234'
  #     )
  #   )
  #
  # @example Add a time statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::Time.new(
  #       time: '+2022-08-12T00:00:00Z',
  #       time_zone: 0,
  #       precision: 11,
  #       calendar_model: 'https://wikidata.org/entity/Q1234'
  #     )
  #   )
  #
  # @example Add a Wikibase item statement.
  #   wikidatum_client.add_statement(
  #     id: 'Q123',
  #     property: 'P124',
  #     datavalue: Wikidatum::DataValueType::WikibaseEntityId.new(
  #       entity_type: 'item',
  #       numeric_id: 1234,
  #       id: 'Q1234'
  #     )
  #   )
  #
  # @param id [String] the ID of the item on which the statement will be added.
  # @param property [String] property ID in the format 'P123'.
  # @param datavalue [Wikidatum::DataValueType::GlobeCoordinate, Wikidatum::DataValueType::MonolingualText, Wikidatum::DataValueType::Quantity, Wikidatum::DataValueType::WikibaseString, Wikidatum::DataValueType::Time, Wikidatum::DataValueType::WikibaseEntityId, Wikidatum::DataValueType::NoValue, Wikidatum::DataValueType::SomeValue] the datavalue of the statement being created.
  # @param datatype [String, nil] if nil, it'll determine the type based on what was passed for the statement argument. This may differ from the type of the Statement's datavalue (for example with the 'url' type).
  # @param qualifiers [Hash<String, Array<Wikidatum::Snak>>]
  # @param references [Array<Wikidatum::Reference>]
  # @param rank [String]
  # @param tags [Array<String>]
  # @param comment [String, nil]
  # @return [Boolean] True if the request succeeded.
  def add_statement(id:, property:, datavalue:, datatype: nil, qualifiers: {}, references: [], rank: 'normal', tags: [], comment: nil)
    raise ArgumentError, "#{id.inspect} is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'." unless id.is_a?(Integer) || id.match?(ITEM_REGEX)

    id = coerce_item_id(id)

    # Unless datatype is set explicitly by the caller, just assume we can pull the
    # default from the datavalue class.
    datatype ||= datavalue.wikibase_datatype

    case datavalue.class.to_s
    when 'Wikidatum::DataValueType::NoValue'
      statement_hash = {
        mainsnak: {
          snaktype: 'novalue',
          property: property,
          datatype: datatype
        }
      }
    when 'Wikidatum::DataValueType::SomeValue'
      statement_hash = {
        mainsnak: {
          snaktype: 'somevalue',
          property: property,
          datatype: datatype
        }
      }
    when 'Wikidatum::DataValueType::GlobeCoordinate', 'Wikidatum::DataValueType::MonolingualText', 'Wikidatum::DataValueType::Quantity', 'Wikidatum::DataValueType::WikibaseString', 'Wikidatum::DataValueType::Time', 'Wikidatum::DataValueType::WikibaseEntityId'
      statement_hash = {
        mainsnak: {
          snaktype: 'value',
          property: property,
          datatype: datatype,
          datavalue: {
            type: datavalue.wikibase_type,
            value: datavalue.marshal_dump
          }
        }
      }
    else
      raise ArgumentError, "Expected an instance of one of Wikidatum::DataValueType's subclasses for datavalue, but got #{datavalue.inspect}."
    end

    body = { statement: statement_hash.merge({ qualifiers: qualifiers, references: references, rank: rank, type: "statement" }) }

    response = post_request("/entities/items/#{id}/statements", body, tags: tags, comment: comment)

    puts JSON.pretty_generate(response) if ENV['DEBUG']

    response.success?
  end

  # Delete a statement from an item.
  #
  # @example
  #   wikidatum_client.delete_statement(
  #     id: 'Q123$4543523c-1d1d-1111-1e1e-11b11111b1f1',
  #     comment: "Deleting this statement because it's bad."
  #   )
  #
  # @param id [String] the ID of the statemnt being deleted.
  # @param tags [Array<String>]
  # @param comment [String, nil]
  # @return [Boolean] True if the request succeeded.
  def delete_statement(id:, tags: [], comment: nil)
    raise ArgumentError, "#{id.inspect} is an invalid Wikibase Statement ID. Must be a string in the format 'Q123$f004ec2b-4857-3b69-b370-e8124f5bd3ac'." unless id.match?(STATEMENT_REGEX)

    response = delete_request("/statements/#{id}", tags: tags, comment: comment)

    puts JSON.pretty_generate(response) if ENV['DEBUG']

    response.success?
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

    # Error handling if it doesn't return a 200
    unless response.success?
      puts 'Something went wrong with this request!'
      puts "Status Code: #{response.status}"
      puts response.body.inspect
    end

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
    body[:tags] = tags unless tags.empty?
    body[:comment] = comment unless comment.nil?

    response = Faraday.post(url) do |req|
      req.body = JSON.generate(body)
      req.headers = universal_headers
    end

    puts response.body.inspect if ENV['DEBUG']

    response
  end

  # Make a DELETE request to a given Wikibase endpoint.
  #
  # @param path [String] The relative path for the API endpoint.
  # @param tags [Array<String>] The tags to apply to the edit being made by this request, for PUT/POST/DELETE requests.
  # @param comment [String] The edit description, for PUT/POST/DELETE requests.
  # @return [Hash] JSON response, parsed into a hash.
  def delete_request(path, tags: [], comment: nil)
    url = "#{api_url}#{path}"

    body = {}
    body[:bot] = @bot
    body[:tags] = tags unless tags.empty?
    body[:comment] = comment unless comment.nil?

    response = Faraday.delete(url) do |req|
      req.body = JSON.generate(body)
      req.headers = universal_headers
    end

    puts response.body.inspect if ENV['DEBUG']

    # Error handling if it doesn't return a 200
    unless response.success?
      puts 'Something went wrong with this request!'
      puts "Status Code: #{response.status}"
      puts response.body.inspect
    end

    response
  end

  # Coerce an Item ID in the formats 'Q123', '123' or 123 into a consistent
  # 'Q123' format. We need to have the ID in the format 'Q123' for the API
  # request, which is why coercion is necessary.
  #
  # @param id [String, Integer]
  # @return [String]
  def coerce_item_id(id)
    return id if id.to_s.start_with?('Q')

    "Q#{id}"
  end
end
