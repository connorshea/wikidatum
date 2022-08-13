# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The time type datavalue JSON looks like this:
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
#
# We do not include before and after because the documentation states that
# they're unused and "may be removed in the future".
#
# NOTE: For consistency with Ruby snake_case attribute names, `timezone` from
# the API is represented as `time_zone` and `calendarmodel` is
# `calendar_model`. However, we expose aliases so `timezone` and
# `calendarmodel` will still work.
class Wikidatum::DataValueType::Time
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

  # @return [Integer] an integer for the offset (in minutes) from UTC. 0 means
  #   UTC, will currently always be 0 but the Wikibase backend may change that
  #   in the future.
  attr_reader :time_zone

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

  # @!visibility private
  def initialize(time:, time_zone:, precision:, calendar_model:)
    @time = time
    @time_zone = time_zone
    @precision = precision
    @calendar_model = calendar_model
  end

  # @return [Hash]
  def to_h
    {
      time: @time,
      time_zone: @time_zone,
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
    Wikidatum::DataValueType::Base.new(
      type: :time,
      value: new(
        time: data_value_json['time'],
        time_zone: data_value_json['timezone'],
        precision: data_value_json['precision'],
        calendar_model: data_value_json['calendarmodel']
      )
    )
  end

  # @!visibility private
  def marshal_dump
    {
      time: @time,
      timezone: @time_zone,
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

  alias timezone time_zone
  alias calendarmodel calendar_model
end
