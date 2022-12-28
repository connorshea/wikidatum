# frozen_string_literal: true

require 'wikidatum/data_type/base'

# The time type JSON looks like this:
#
# ```json
# {
#   "property": {
#     "id": "P761",
#     "data-type": "time"
#   },
#   "value": {
#     "type": "value",
#     "content": {
#       "time": "+2019-11-14T00:00:00Z",
#       "precision": 11,
#       "calendarmodel": "http://www.wikidata.org/entity/Q1985727"
#     }
#   }
# }
# ```
#
# NOTE: For consistency with Ruby snake_case attribute names, `calendarmodel`
# in the API is `calendar_model`. However, we expose an alias so
# `calendarmodel` will still work.
class Wikidatum::DataType::Time
  # A string representing the time in a format that is very similar to ISO 8601.
  #
  # For example, here are what dates look like for the most common precisions:
  #
  # - years (9): "+2022-00-00T00:00:00Z", meaning "2022"
  # - months (10): "+2022-03-00T00:00:00Z", meaning "March 2022"
  # - days (11): "+2022-01-01T00:00:00Z", meaning "January 1, 2022"
  #
  # NOTE: Due to how precision works, it's probably not a good idea to use the
  # Ruby `Date` or `Time` classes to parse these values unless it's a day-level
  # precision. `Date.parse` will error if you give it a string like
  # "2022-00-00", but it'll handle "2022-01-01" fine. `Time.new` will parse
  # "2022-00-00" as January 1, 2022. There are various other pitfalls that make
  # this generally dangerous unless you're very careful, which is why Wikidatum
  # just handles the time as a string and leaves it to end-users to do what they
  # like with it.
  #
  # @return [String] the time value, in a format like "+2022-01-01T00:00:00Z", though how this should be interpreted depends on the precision.
  attr_reader :time

  # An integer representing the precision of the date, where the integers correspond to the following:
  #
  # - 0: 1 Gigayear
  # - 1: 100 Megayears
  # - 2: 10 Megayears
  # - 3: Megayear
  # - 4: 100 Kiloyears
  # - 5: 10 Kiloyears
  # - 6: millennium
  # - 7: century
  # - 8: 10 years
  # - 9: years
  # - 10: months
  # - 11: days
  # - 12: hours (unused)
  # - 13: minutes (unused)
  # - 14: seconds (unused)
  #
  # Usually only 9, 10, and 11 are used in actual items, though for some items
  # you'll need to handle the other cases.
  #
  # For example, the date August 12, 2022 (aka "2022-08-12") would have a
  # precision of days (11).
  #
  # If the time represented is August 2022 because the value is only precise
  # to the month (e.g. a person who's birth is only known to the month rather
  # than the exact day) that would have a precision of months (10).
  #
  # If the time represented is "2022" because it's only precise to the year,
  # that would have a precision of years (9).
  #
  # @return [Integer]
  attr_reader :precision

  # @return [String] a URL (usually in the same Wikibase instance) representing the given calendar model (e.g. Gregorian, Julian).
  attr_reader :calendar_model

  # @param time [String]
  # @param precision [Integer]
  # @param calendar_model [String]
  # @return [void]
  def initialize(time:, precision:, calendar_model:)
    @time = time
    @precision = precision
    @calendar_model = calendar_model
  end

  # @return [Hash]
  def to_h
    {
      time: @time,
      precision: @precision,
      pretty_precision: pretty_precision,
      calendar_model: @calendar_model
    }
  end

  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'time'
  end

  # @!visibility private
  def self.marshal_load(data_value_json)
    Wikidatum::DataType::Base.new(
      type: :time,
      content: new(
        time: data_value_json['time'],
        precision: data_value_json['precision'],
        calendar_model: data_value_json['calendarmodel']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      time: @time,
      precision: @precision,
      calendarmodel: @calendar_model
    }
  end

  PRETTY_PRECISIONS = {
    0 => :gigayear,
    1 => :'100_megayear',
    2 => :'10_megayear',
    3 => :megayear,
    4 => :'100_kiloyear',
    5 => :'10_kiloyear',
    6 => :millennium,
    7 => :century,
    8 => :decade,
    9 => :year,
    10 => :month,
    11 => :day,
    12 => :hour,
    13 => :minute,
    14 => :second
  }.freeze

  # Returns a symbol representation of the precision, in singular form.
  #
  # Possible values are `:gigayear`, `:'100_megayear'`, `:'10_megayear'`,
  # `:megayear`, `:'100_kiloyear'`, `:'10_kiloyear'`, `:millennium`, `:century`,
  # `:decade`, `:year`, `:month`, `:day`, `:hour`, `:minute`, and `:second`.
  #
  # @return [Symbol]
  def pretty_precision
    PRETTY_PRECISIONS[@precision]
  end

  # Aliases to match the name returned by the REST API.

  alias calendarmodel calendar_model
end
