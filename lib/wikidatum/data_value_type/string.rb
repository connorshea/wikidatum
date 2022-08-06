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
module Wikidatum::DataValueType
  class String < Base
    def self.serialize(data_value_json)
      puts data_value_json
    end
  end
end
