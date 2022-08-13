# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Monolingual Text type datavalue JSON looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": {
#       "text": "South Pole Telescope eyes birth of first massive galaxies",
#       "language": "en"
#     },
#     "type": "monolingualtext"
#   }
# }
# ```
class Wikidatum::DataValueType::MonolingualText
  # @return [String] the language code, e.g. 'en'
  attr_reader :language

  # @return [String]
  attr_reader :text

  # @param language [String]
  # @param text [String]
  # @return [void]
  def initialize(language:, text:)
    @language = language
    @text = text
  end

  # @return [Hash]
  def to_h
    {
      language: @language,
      text: @text
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'monolingualtext'
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataValueType::Base.new(
      type: :monolingual_text,
      value: new(
        language: data_value_json['language'],
        text: data_value_json['text']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      language: @language,
      text: @text
    }
  end
end
