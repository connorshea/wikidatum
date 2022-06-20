# frozen_string_literal: true

require_relative 'wikidatum/client'
require_relative 'wikidatum/item'
require_relative 'wikidatum/qualifier'
require_relative 'wikidatum/reference'
require_relative 'wikidatum/snak'
require_relative 'wikidatum/statement'
require_relative 'wikidatum/term'
require_relative 'wikidatum/version'

module Wikidatum
  class Error < StandardError; end
end
