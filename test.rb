require 'debug'
require 'wikidatum'
require 'json'

wikidatum_client = Wikidatum::Client.new(
  user_agent: 'Test client',
  wikibase_url: 'https://wikidata.beta.wmflabs.org',
  bot: true
)

item = wikidatum_client.item(id: '11')
