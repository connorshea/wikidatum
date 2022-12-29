# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The Monolingual Text type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P13432",
#     "data-type": "monolingualtext"
#   },
#   "value": {
#     "type": "value",
#     "content": {
#       "text": "foo",
#       "language": "en-gb"
#     }
#   }
# }
# ```
class Wikidatum::DataType::MonolingualText
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

  HumanizedStruct = Struct.new(:language, :text, keyword_init: true)

  # The content of the data value object. Use this to get a more sensible
  # representation of the statement's contents.
  #
  # @return [HumanizedStruct<language, text>]
  def humanized
    HumanizedStruct.new(to_h)
  end

  # @return [Symbol]
  def self.symbolized_name
    :monolingual_text
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataType::Base.new(
      type: symbolized_name,
      content: new(
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
