# frozen_string_literal: true

require 'wikidatum/data_value_type/base'

# The String type datavalue looks like this:
#
# ```json
# {
#   "datavalue": {
#     "value": "Foobar",
#     "type": "string"
#   }
# }
# ```
class Wikidatum::DataValueType::String < Wikidatum::DataValueType::Base
  def self.serialize(string)
    new(type: :string, value: string)
  end
end
