# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The time type datavalue looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": {
#       "time": "+2019-11-14T00:00:00Z",
#       "timezone": 0,
#       "before": 0,
#       "after": 0,
#       "precision": 11,
#       "calendarmodel": "http://www.wikidata.org/entity/Q1985727"
#     },
#     "type": "time"
#   }
# }
# ```
class Wikidatum::DataValueType::Time < Wikidatum::DataValueType::Base
  def self.serialize(data_value_json)
    new(
      type: :time,
      value: {
        time: data_value_json['time'],
        timezone: data_value_json['timezone'],
        before: data_value_json['before'],
        after: data_value_json['after'],
        precision: data_value_json['precision'],
        calendarmodel: data_value_json['calendarmodel']
      }
    )
  end
end
