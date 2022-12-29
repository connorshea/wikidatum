# Wikidatum

This gem supports making requests to the [new Wikidata/Wikibase REST API](https://doc.wikimedia.org/Wikibase/master/js/rest-api/).

The [Wikimedia Docs on the Wikibase REST API data format differences](https://doc.wikimedia.org/Wikibase/master/php/rest_data_format_differences.html) are also very useful for interacting with/contributing to this gem.

**The gem is currently in early development and is not ready for production usage**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wikidatum'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wikidatum

## Usage

You can view the YARD docs on GitHub Pages [here](https://connorshea.github.io/wikidatum/index.html). Generally, you'll want to look at the docs for {Wikidatum::Client} to get started.

Currently, the gem is able to hit a few of the basic endpoints, and currently has no way to provide authentication. The additional features will be added later.

```ruby
require 'wikidatum'

wikidatum_client = Wikidatum::Client.new(
  user_agent: 'REPLACE ME WITH THE NAME OF YOUR BOT!',
  # Currently only the beta site has the API available, you'll
  # likely want to use wikidata.org once it's stable.
  wikibase_url: 'https://wikidata.beta.wmflabs.org',
  # NOTE: To edit as a bot, you need to authenticate as a user with the Bot
  # flag. If you don't have that flag on your Wikibase User, you'll get a
  # 403 error.
  bot: true
)

# Get an item from the Wikibase instance.
item = wikidatum_client.item(id: 'Q2') #=> Wikidatum::Item

# Get the statements from the item.
item.statements #=> Array<Wikidatum::Statement>

# Get the statments for property P123 on the item.
item.statements(properties: ['P123']) #=> Array<Wikidatum::Statement>

# Get all the labels for the item.
item.labels #=> Array<Wikidatum::Term>

# Get the English label for the item.
item.label(lang: :en) #=> Wikidatum::Term

# Get the actual value for the label.
item.label(lang: :en).value #=> "Earth"

# Get the values for all English aliases on this item.
item.aliases(langs: [:en]).map(&:value) #=> ["Planet Earth", "Pale Blue Dot"]

# Get all labels for a given item.
wikidatum_client.labels(id: 'Q2') #=> Array<Wikidatum::Term>

# Get a specific statement from its ID.
statement_id = 'Q123$4543523c-1d1d-1111-1e1e-11b11111b1f1'
statement = wikidatum_client.statement(id: statement_id) #=> Wikidatum::Statement

# Add a statement to Q193581 for P577 (publication date) that has a time value of November 16, 2004.
wikidatum_client.add_statement(
  id: 'Q193581',
  property: 'P577',
  value: Wikidatum::DataType::Time.new(
    time: '+2004-11-16T00:00:00Z',
    precision: 11,
    calendar_model: 'https://www.wikidata.org/entity/Q12138'
  )
)

# Delete a statement and include an edit summary.
wikidatum_client.delete_statement(
  id: 'Q123$4543523c-1d1d-1111-1e1e-11b11111b1f1',
  comment: 'Deleting this statement because it is inaccurate.'
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/connorshea/wikidatum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
