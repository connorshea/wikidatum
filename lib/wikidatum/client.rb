# frozen_string_literal: true

require 'faraday'
require 'faraday/net_http'

module Wikidatum
  class Client
    ITEM_REGEX = /^Q?\d+$/.freeze
    PROPERTY_REGEX = /^P?\d+$/.freeze
    STATEMENT_REGEX = /^Q?\d+\$[\w-]+$/.freeze
    VALID_RANKS = ['preferred', 'normal', 'deprecated'].freeze
    VALID_DATA_TYPES = [
      'Wikidatum::DataType::CommonsMedia',
      'Wikidatum::DataType::ExternalId',
      'Wikidatum::DataType::GlobeCoordinate',
      'Wikidatum::DataType::MonolingualText',
      'Wikidatum::DataType::NoValue',
      'Wikidatum::DataType::Quantity',
      'Wikidatum::DataType::SomeValue',
      'Wikidatum::DataType::Time',
      'Wikidatum::DataType::WikibaseItem',
      'Wikidatum::DataType::WikibaseString',
      'Wikidatum::DataType::WikibaseUrl'
    ].freeze

    # @return [String] the root URL of the Wikibase instance we want to interact
    #   with. If not provided, will default to Wikidata.
    attr_reader :wikibase_url

    # @return [Boolean] whether this client instance should identify itself
    #   as a bot when making requests.
    attr_reader :bot

    # @return [String] the UserAgent header to send with all requests to the
    #   Wikibase API.
    attr_reader :user_agent

    # @return [Boolean] whether this client should allow non-GET requests if
    #   authentication hasn't been provided. Defaults to false.
    attr_reader :allow_ip_edits

    # Create a new Wikidatum::Client to interact with the Wikibase REST API.
    #
    # @example
    #  wikidatum_client = Wikidatum::Client.new(
    #    user_agent: 'Bot Name',
    #    wikibase_url: 'https://www.wikidata.org',
    #    bot: true
    #  )
    #
    # @param user_agent [String] The UserAgent header to send with all requests
    #   to the Wikibase API. This will be prepended with the string "Wikidatum
    #   Ruby gem vX.X.X:".
    # @param wikibase_url [String] The root URL of the Wikibase instance we want
    #   to interact with. If not provided, will default to
    #   `https://www.wikidata.org`. Do not include a `/` at the end of the URL.
    # @param bot [Boolean] Whether requests sent by this client instance should
    #   be registered as bot requests. Defaults to `true`.
    # @param allow_ip_edits [Boolean] whether this client should allow non-GET
    #   requests if authentication hasn't been provided. Defaults to false. If
    #   this is set to true, the IP address of the device from which the
    #   request was sent will be credited for the edit. Make sure not to allow
    #   these edits if you don't want your IP address (and in many cases, a
    #   very close approximation of your physical location) exposed publicly.
    # @return [Wikidatum::Client]
    def initialize(user_agent:, wikibase_url: 'https://www.wikidata.org', bot: true, allow_ip_edits: false)
      raise ArgumentError, "Wikibase URL must not end with a `/`, got #{wikibase_url.inspect}." if wikibase_url.end_with?('/')

      @user_agent = "Wikidatum Ruby gem v#{Wikidatum::VERSION}: #{user_agent}"
      @wikibase_url = wikibase_url
      @bot = bot
      @allow_ip_edits = allow_ip_edits

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

    # @!private
    CONTENT_DATA_TYPES = [
      'Wikidatum::DataType::CommonsMedia',
      'Wikidatum::DataType::ExternalId',
      'Wikidatum::DataType::GlobeCoordinate',
      'Wikidatum::DataType::MonolingualText',
      'Wikidatum::DataType::Quantity',
      'Wikidatum::DataType::WikibaseString',
      'Wikidatum::DataType::Time',
      'Wikidatum::DataType::WikibaseItem',
      'Wikidatum::DataType::WikibaseUrl'
    ].freeze

    # Add a statement to an item.
    #
    # NOTE: Adding references/qualifiers with `add_statement` is untested and
    # effectively unsupported for now.
    #
    # @example Add a string statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P23',
    #     value: Wikidatum::DataType::WikibaseString.new(string: 'Foo'),
    #     comment: 'Adding something or another.'
    #   )
    #
    # @example Add a 'no value' statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::NoValue.new(
    #       type: :no_value,
    #       value: nil
    #     )
    #   )
    #
    # @example Add an 'unknown value' statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::SomeValue.new(
    #       type: :some_value,
    #       value: nil
    #     )
    #   )
    #
    # @example Add a globe coordinate statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::GlobeCoordinate.new(
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
    #     value: Wikidatum::DataType::MonolingualText.new(
    #       language: 'en',
    #       text: 'Foobar'
    #     )
    #   )
    #
    # @example Add a quantity statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::Quantity.new(
    #       amount: '+12',
    #       unit: 'https://wikidata.org/entity/Q1234'
    #     )
    #   )
    #
    # @example Add a time statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::Time.new(
    #       time: '+2022-08-12T00:00:00Z',
    #       precision: 11,
    #       calendar_model: 'https://wikidata.org/entity/Q1234'
    #     )
    #   )
    #
    # @example Add a Wikibase item statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::WikibaseItem.new(
    #       id: 'Q1234'
    #     )
    #   )
    #
    # @example Add a URL statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::WikibaseUrl.new(
    #       string: 'https://example.com'
    #     )
    #   )
    #
    # @example Add an External ID statement.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::ExternalId.new(
    #       string: '123'
    #     )
    #   )
    #
    # @example Add a statement for an image, video, or audio file from Wikimedia Commons.
    #   wikidatum_client.add_statement(
    #     id: 'Q123',
    #     property: 'P124',
    #     value: Wikidatum::DataType::CommonsMedia.new(
    #       string: 'FooBar.jpg'
    #     )
    #   )
    #
    # @param id [String, Integer] the ID of the item on which the statement will be added.
    # @param property [String, Integer] property ID in the format 'P123', or an integer.
    # @param value [Wikidatum::DataType::CommonsMedia, Wikidatum::DataType::ExternalId, Wikidatum::DataType::GlobeCoordinate, Wikidatum::DataType::MonolingualText, Wikidatum::DataType::Quantity, Wikidatum::DataType::WikibaseString, Wikidatum::DataType::Time, Wikidatum::DataType::WikibaseItem, Wikidatum::DataType::WikibaseUrl, Wikidatum::DataType::NoValue, Wikidatum::DataType::SomeValue] the value of the statement being created.
    # @param qualifiers [Array<Wikidatum::Qualifier>]
    # @param references [Array<Wikidatum::Reference>]
    # @param rank [String, Symbol] Valid ranks are 'preferred', 'normal', or
    #   'deprecated'. Defaults to 'normal'. Also accepts Symbol for these ranks.
    # @param tags [Array<String>]
    # @param comment [String, nil]
    # @return [Boolean] True if the request succeeded.
    def add_statement(id:, property:, value:, qualifiers: [], references: [], rank: 'normal', tags: [], comment: nil)
      raise ArgumentError, "#{id.inspect} is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'." unless id.is_a?(Integer) || id.match?(ITEM_REGEX)
      raise ArgumentError, "#{property.inspect} is an invalid Wikibase PID. Must be an integer, a string representation of an integer, or in the format 'P123'." unless property.is_a?(Integer) || property.match?(PROPERTY_REGEX)
      raise ArgumentError, "#{rank.inspect} is an invalid rank. Must be normal, preferred, or deprecated." unless VALID_RANKS.include?(rank.to_s)
      raise ArgumentError, "Expected an instance of one of Wikidatum::DataType's subclasses for value, but got #{value.inspect}." unless VALID_DATA_TYPES.include?(value.class.to_s)

      id = coerce_item_id(id)
      property = coerce_property_id(property)

      case value.class.to_s
      when 'Wikidatum::DataType::NoValue'
        statement_hash = {
          property: {
            id: property
          },
          value: {
            type: 'novalue'
          }
        }
      when 'Wikidatum::DataType::SomeValue'
        statement_hash = {
          property: {
            id: property
          },
          value: {
            type: 'somevalue'
          }
        }
      when *CONTENT_DATA_TYPES
        statement_hash = {
          property: {
            id: property
          },
          value: {
            type: 'value',
            content: value.marshal_dump
          }
        }
      end

      body = {
        statement: statement_hash.merge(
          {
            qualifiers: qualifiers,
            references: references,
            rank: rank.to_s
          }
        )
      }

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

    # Is the current instance of Client authenticated as a Wikibase user?
    #
    # @return [Boolean]
    def authenticated?
      # TODO: Make it possible for this to be true once authentication
      #   is implemented.
      false
    end

    # Does the current instance of Client allow anonymous IP-based edits?
    #
    # @return [Boolean]
    def allow_ip_edits?
      @allow_ip_edits
    end

    # Is the current instance of Client editing as a bot?
    #
    # @return [Boolean]
    def bot?
      @bot
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
    def post_request(path, body = {}, tags: [], comment: nil)
      ensure_edit_permitted!

      url = "#{api_url}#{path}"

      body[:bot] = @bot
      body[:tags] = tags unless tags.empty?
      body[:comment] = comment unless comment.nil?

      response = Faraday.post(url) do |req|
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

    # Make a DELETE request to a given Wikibase endpoint.
    #
    # @param path [String] The relative path for the API endpoint.
    # @param tags [Array<String>] The tags to apply to the edit being made by this request, for PUT/POST/DELETE requests.
    # @param comment [String] The edit description, for PUT/POST/DELETE requests.
    # @return [Hash] JSON response, parsed into a hash.
    def delete_request(path, tags: [], comment: nil)
      ensure_edit_permitted!

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

    # Coerce a Property ID in the formats 'P123', '123' or 123 into a consistent
    # 'P123' format. We need to have the ID in the format 'P123' for the API
    # request, which is why coercion is necessary.
    #
    # @param property_id [String, Integer]
    # @return [String]
    def coerce_property_id(property_id)
      return property_id if property_id.to_s.start_with?('P')

      "P#{property_id}"
    end

    # Check if authentication has been provided, and then check if IP edits
    # are allowed. If neither condition returns true, raise an error.
    #
    # Also check if the user is performing IP edits as a bot, which will
    # always return a 403 error from the REST API, and return a specific
    # error message if so.
    #
    # @return [void]
    # @raise [DisallowedIpEditError, DisallowedBotEditError]
    def ensure_edit_permitted!
      raise DisallowedIpEditError if !authenticated? && !allow_ip_edits?
      raise DisallowedBotEditError if !authenticated? && bot?
    end
  end
end
