# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The Monolingual Text type datavalue JSON looks like this:
#
#  {
#    "datavalue": {
#      "value": {
#        "text": "South Pole Telescope eyes birth of first massive galaxies",
#        "language": "en"
#      },
#      "type": "monolingualtext"
#    }
#  }
class Wikidatum::DataValueType::MonolingualText < Wikidatum::DataValueType::Base
  # @!visibility private
  def self.marshal_load(data_value_json)
    new(type: :monolingual_text, value: { language: data_value_json['language'], text: data_value_json['text'] })
  end
end
