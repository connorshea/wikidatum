# frozen_string_literal: true

require 'wikidatum/data_type/base'
require 'wikidatum/data_type/wikibase_string'

# Identical to the WikibaseString type, but we'll change some metadata to make
# it clear that they're technically distinct types.
class Wikidatum::DataType::ExternalId < Wikidatum::DataType::WikibaseString
  # The "type" value used by Wikibase, for use when creating/updating statements.
  #
  # @return [String]
  def wikibase_type
    'external-id'
  end

  # @return [Symbol]
  def self.symbolized_name
    :external_id
  end
end
