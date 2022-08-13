# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::Client do
  # Convenience method for creating a new client
  def create_client(user_agent: 'Bot name', wikibase_url: 'https://example.com', bot: true)
    Wikidatum::Client.new(user_agent: user_agent, wikibase_url: wikibase_url, bot: bot)
  end

  describe 'initialize' do
    it 'raises when passed a URL with a trailing slash' do
      assert_raises(ArgumentError, "Wikibase URL must not end with a `/`, got 'https://example.com/'") do
        create_client(wikibase_url: 'https://example.com/')
      end
    end
  end

  describe '#item' do
    before do
      stub_request(:get, 'https://example.com/w/rest.php/wikibase/v0/entities/items/Q124')
        .to_return(
          status: 200,
          body: File.read('test/fixtures/q124.json'),
          headers: {}
        )
    end

    it 'raises when given an invalid item ID' do
      assert_raises(ArgumentError, "'bad id' is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'.") do
        create_client.item(id: 'bad id')
      end
    end

    it 'returns a valid item' do
      item = create_client.item(id: 'Q124')
      assert_kind_of Wikidatum::Item, item
    end

    it 'returns a valid item when passing an integer' do
      item = create_client.item(id: 124)
      assert_kind_of Wikidatum::Item, item
    end

    it 'returns a valid item when passing an stringified integer' do
      item = create_client.item(id: '124')
      assert_kind_of Wikidatum::Item, item
    end
  end
end
