# frozen_string_literal: true

require 'test_helper'

describe 'Wikidatum::Client#add_statement' do
  # Convenience method for creating a new client
  def create_client(user_agent: 'Bot name', wikibase_url: 'https://example.com', bot: true, allow_ip_edits: true)
    Wikidatum::Client.new(
      user_agent: user_agent,
      wikibase_url: wikibase_url,
      bot: bot,
      allow_ip_edits: allow_ip_edits
    )
  end

  describe '#add_statement' do
    let(:item_id) { 'Q124' }
    let(:property) { 'P625' }

    describe 'creating a string-type statement' do
      let(:datavalue) { Wikidatum::DataValueType::WikibaseString.new(string: 'test data') }
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "string",
              datavalue: {
                type: "string",
                value: "test data"
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})

        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true, tags: ['bar'], comment: 'adding string property' }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'raises when given an invalid item ID' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: 'bad id', property: 'P123', datavalue: nil)
        end
        assert_equal "\"bad id\" is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'.", err.message
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end

      it 'returns true when passed an integer for id' do
        response = create_client.add_statement(
          id: 124,
          property: property,
          datavalue: datavalue
        )

        assert response
      end

      it 'returns true when also sending tags and a comment' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue,
          tags: ['bar'],
          comment: 'adding string property'
        )

        assert response
      end
    end

    describe 'creating a time-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::Time.new(
          time: '+2022-08-12T00:00:00Z',
          precision: 11,
          calendar_model: 'https://wikidata.org/entity/Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "time",
              datavalue: {
                type: "time",
                value: {
                  time: '+2022-08-12T00:00:00Z',
                  precision: 11,
                  calendarmodel: 'https://wikidata.org/entity/Q1234'
                }
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a quantity-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::Quantity.new(
          amount: '+1',
          unit: 'https://wikidata.org/entity/Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "quantity",
              datavalue: {
                type: "quantity",
                value: {
                  amount: '+1',
                  upperBound: nil,
                  lowerBound: nil,
                  unit: 'https://wikidata.org/entity/Q1234'
                }
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a monolingualtext-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::MonolingualText.new(
          language: 'en',
          text: 'Foobar'
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "monolingualtext",
              datavalue: {
                type: "monolingualtext",
                value: {
                  language: 'en',
                  text: 'Foobar'
                }
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a Wikibase Item-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::WikibaseItem.new(
          entity_type: 'item',
          numeric_id: 1234,
          id: 'Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "wikibase-item",
              datavalue: {
                type: "wikibase-item",
                value: {
                  'entity-type': "item",
                  'numeric-id': 1234,
                  id: "Q1234"
                }
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a GlobeCoordinate-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::GlobeCoordinate.new(
          latitude: 52.516666666667,
          longitude: 13.383333333333,
          precision: 0.016666666666667,
          globe: 'https://wikidata.org/entity/Q2'
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "value",
              property: property,
              datatype: "globe-coordinate",
              datavalue: {
                type: "globecoordinate",
                value: {
                  latitude: 52.516666666667,
                  longitude: 13.383333333333,
                  precision: 0.016666666666667,
                  globe: 'https://wikidata.org/entity/Q2'
                }
              }
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a SomeValue-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::SomeValue.new(
          type: :some_value,
          value: nil
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "somevalue",
              property: property,
              datatype: "string"
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a NoValue-type statement' do
      let(:datavalue) do
        Wikidatum::DataValueType::NoValue.new(
          type: :no_value,
          value: nil
        )
      end
      let(:output_body) do
        {
          statement: {
            mainsnak: {
              snaktype: "novalue",
              property: property,
              datatype: "string"
            },
            qualifiers: {},
            references: [],
            rank: "normal",
            type: "statement"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: true }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          datavalue: datavalue
        )

        assert response
      end
    end

    describe 'creating a statement with a rank' do
      it 'raises an error when given an invalid rank' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, datavalue: nil, rank: 'foobar')
        end
        assert_equal "\"foobar\" is an invalid rank. Must be normal, preferred, or deprecated.", err.message
      end

      it 'raises an error when given an invalid symbol rank' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, datavalue: nil, rank: :foobar)
        end
        assert_equal ":foobar is an invalid rank. Must be normal, preferred, or deprecated.", err.message
      end

      describe 'using a valid rank' do
        let(:datavalue) do
          Wikidatum::DataValueType::NoValue.new(
            type: :no_value,
            value: nil
          )
        end
        let(:output_body) do
          {
            statement: {
              mainsnak: {
                snaktype: "novalue",
                property: property,
                datatype: "string"
              },
              qualifiers: {},
              references: [],
              rank: "preferred",
              type: "statement"
            }
          }
        end

        before do
          stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
            .with(body: output_body.merge({ bot: true }).to_json)
            .to_return(status: 200, body: '', headers: {})
        end

        it 'returns true' do
          response = create_client.add_statement(
            id: item_id,
            property: property,
            datavalue: datavalue,
            rank: 'preferred'
          )

          assert response
        end

        it 'returns true with symbol rank' do
          response = create_client.add_statement(
            id: item_id,
            property: property,
            datavalue: datavalue,
            rank: :preferred
          )

          assert response
        end
      end
    end

    describe 'creating a statement with an invalid datavalue' do
      it 'raises an error' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, datavalue: true)
        end
        assert_equal "Expected an instance of one of Wikidatum::DataValueType's subclasses for datavalue, but got true.", err.message
      end
    end
  end
end
