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
    let(:item_id) { 'Q124' }

    before do
      stub_request(:get, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}")
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
      item = create_client.item(id: item_id)
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

  describe '#statement' do
    let(:statement_id) { 'Q124$adacda34-46c4-2515-7aa9-ac448c8bfded' }

    before do
      stub_request(:get, "https://example.com/w/rest.php/wikibase/v0/statements/#{statement_id}")
        .to_return(
          status: 200,
          body: File.read('test/fixtures/q124-statement1.json'),
          headers: {}
        )
    end

    it 'raises when given an invalid statement ID' do
      assert_raises(ArgumentError, "'bad id' is an invalid Wikibase Statement ID. Must be a string in the format 'Q123$f004ec2b-4857-3b69-b370-e8124f5bd3ac'.") do
        create_client.statement(id: 'bad id')
      end
    end

    it 'returns a valid statement' do
      statement = create_client.statement(id: statement_id)
      assert_kind_of Wikidatum::Statement, statement
    end
  end

  describe '#delete_statement' do
    let(:statement_id) { 'Q124$adacda34-46c4-2515-7aa9-ac448c8bfded' }

    before do
      stub_request(:delete, "https://example.com/w/rest.php/wikibase/v0/statements/#{statement_id}")
        .with(body: JSON.generate({ bot: true }))
        .to_return(status: 200, body: '', headers: {})

      stub_request(:delete, "https://example.com/w/rest.php/wikibase/v0/statements/#{statement_id}")
        .with(body: JSON.generate({ bot: true, tags: ['foo'], comment: 'deleting this statement for reasons...' }))
        .to_return(status: 200, body: '', headers: {})
    end

    it 'raises when given an invalid statement ID' do
      assert_raises(ArgumentError, "'bad id' is an invalid Wikibase Statement ID. Must be a string in the format 'Q123$f004ec2b-4857-3b69-b370-e8124f5bd3ac'.") do
        create_client.delete_statement(id: 'bad id')
      end
    end

    it 'returns true' do
      response = create_client.delete_statement(id: statement_id)
      assert response
    end

    it 'returns true when also sending tags and a comment' do
      response = create_client.delete_statement(
        id: statement_id,
        tags: ['foo'],
        comment: 'deleting this statement for reasons...'
      )

      assert response
    end
  end
end
