# frozen_string_literal: true

require 'test_helper'

describe 'Wikidatum::Client#add_statement' do
  # Convenience method for creating a new client
  def create_client(user_agent: 'Bot name', wikibase_url: 'https://example.com', bot: false, allow_ip_edits: true)
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
      let(:datavalue) { Wikidatum::DataType::WikibaseString.new(string: 'test data') }
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: 'test data'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})

        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false, tags: ['bar'], comment: 'adding string property' }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'raises when given an invalid item ID' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: 'bad id', property: 'P123', value: nil)
        end
        assert_equal "\"bad id\" is an invalid Wikibase QID. Must be an integer, a string representation of an integer, or in the format 'Q123'.", err.message
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end

      it 'returns true when passed an integer for id' do
        response = create_client.add_statement(
          id: 124,
          property: property,
          value: datavalue
        )

        assert response
      end

      it 'returns true when also sending tags and a comment' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue,
          tags: ['bar'],
          comment: 'adding string property'
        )

        assert response
      end
    end

    describe 'creating a time-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::Time.new(
          time: '+2022-08-12T00:00:00Z',
          precision: 11,
          calendar_model: 'https://wikidata.org/entity/Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: {
                time: '+2022-08-12T00:00:00Z',
                precision: 11,
                calendarmodel: 'https://wikidata.org/entity/Q1234'
              }
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a quantity-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::Quantity.new(
          amount: '+1',
          unit: 'https://wikidata.org/entity/Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: {
                amount: '+1',
                unit: 'https://wikidata.org/entity/Q1234'
              }
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a monolingualtext-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::MonolingualText.new(
          language: 'en',
          text: 'Foobar'
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: {
                language: 'en',
                text: 'Foobar'
              }
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a Wikibase Item-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::WikibaseItem.new(
          id: 'Q1234'
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: "Q1234"
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a GlobeCoordinate-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::GlobeCoordinate.new(
          latitude: 52.516666666667,
          longitude: 13.383333333333,
          precision: 0.016666666666667,
          globe: 'https://wikidata.org/entity/Q2'
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: {
                latitude: 52.516666666667,
                longitude: 13.383333333333,
                precision: 0.016666666666667,
                globe: 'https://wikidata.org/entity/Q2'
              }
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating an ExternalId-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::ExternalId.new(string: '123')
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: '123'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a CommonsMedia-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::CommonsMedia.new(string: 'FooBar.jpg')
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: 'FooBar.jpg'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a WikibaseUrl-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::WikibaseUrl.new(string: 'https://example.com')
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'value',
              content: 'https://example.com'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a SomeValue-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::SomeValue.new(
          type: :some_value,
          content: nil
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'somevalue'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a NoValue-type statement' do
      let(:datavalue) do
        Wikidatum::DataType::NoValue.new(
          type: :no_value,
          content: nil
        )
      end
      let(:output_body) do
        {
          statement: {
            property: {
              id: property
            },
            value: {
              type: 'novalue'
            },
            qualifiers: [],
            references: [],
            rank: "normal"
          }
        }
      end

      before do
        stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
          .with(body: output_body.merge({ bot: false }).to_json)
          .to_return(status: 200, body: '', headers: {})
      end

      it 'returns true' do
        response = create_client.add_statement(
          id: item_id,
          property: property,
          value: datavalue
        )

        assert response
      end
    end

    describe 'creating a statement with a rank' do
      it 'raises an error when given an invalid rank' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, value: nil, rank: 'foobar')
        end
        assert_equal "\"foobar\" is an invalid rank. Must be normal, preferred, or deprecated.", err.message
      end

      it 'raises an error when given an invalid symbol rank' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, value: nil, rank: :foobar)
        end
        assert_equal ":foobar is an invalid rank. Must be normal, preferred, or deprecated.", err.message
      end

      describe 'using a valid rank' do
        let(:datavalue) do
          Wikidatum::DataType::NoValue.new(
            type: :no_value,
            content: nil
          )
        end
        let(:output_body) do
          {
            statement: {
              property: {
                id: property
              },
              value: {
                type: 'novalue'
              },
              qualifiers: [],
              references: [],
              rank: "preferred"
            }
          }
        end

        before do
          stub_request(:post, "https://example.com/w/rest.php/wikibase/v0/entities/items/#{item_id}/statements")
            .with(body: output_body.merge({ bot: false }).to_json)
            .to_return(status: 200, body: '', headers: {})
        end

        it 'returns true' do
          response = create_client.add_statement(
            id: item_id,
            property: property,
            value: datavalue,
            rank: 'preferred'
          )

          assert response
        end

        it 'returns true with symbol rank' do
          response = create_client.add_statement(
            id: item_id,
            property: property,
            value: datavalue,
            rank: :preferred
          )

          assert response
        end
      end
    end

    describe 'creating a statement with an invalid datavalue' do
      it 'raises an error' do
        err = assert_raises(ArgumentError) do
          create_client.add_statement(id: item_id, property: property, value: true)
        end
        assert_equal "Expected an instance of one of Wikidatum::DataType's subclasses for value, but got true.", err.message
      end
    end
  end
end
