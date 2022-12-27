# frozen_string_literal: true

require 'wikidatum/client'
require 'wikidatum/data_value_type'
require 'wikidatum/item'
require 'wikidatum/qualifier'
require 'wikidatum/reference'
require 'wikidatum/sitelink'
require 'wikidatum/snak'
require 'wikidatum/statement'
require 'wikidatum/term'
require 'wikidatum/version'

module Wikidatum
  class Error < StandardError; end

  # If the Wikidatum::Client is set to disallow IP Edits (the default) and no
  # authentication has been provided, this error will be raised when performing
  # any non-GET requests.
  class DisallowedIpEditError < Error
    def message
      'No authentication provided. If you want to perform unauthenticated edits and are comfortable exposing your IP address publicly, set `allow_ip_edits: true` when instantiating your client with `Wikidatum::Client.new`.'
    end
  end

  # rubocop:disable Naming/ConstantName

  # These language codes are not enforced, you can pass whatever language code
  # you want, even if it's not represented in this list. The purpose of this
  # is to provide helper constants to allow writing more readable code.
  #
  # This will only cover some of the most common language codes, not all of
  # them.
  module LanguageCodes
    Arabic = 'ar'
    BrazilianPortuguese = 'pt-br'
    Chinese = 'zh'
    Dutch = 'nl'
    English = 'en'
    EnglishUK = 'en-gb'
    French = 'fr'
    German = 'de'
    Hebrew = 'he'
    Hindi = 'hi'
    Italian = 'it'
    Polish = 'pl'
    Portuguese = 'pt'
    Russian = 'ru'
    SimplifiedChinese = 'zh-hans'
    Spanish = 'es'
    TraditionalChinese = 'zh-hant'
    Turkish = 'tr'
    Ukrainian = 'uk'
    # rubocop:enable Naming/ConstantName
  end

  module DataValueType
    # rubocop:disable Lint/SymbolConversion
    DATA_VALUE_TYPES = {
      'globe-coordinate': 'Wikidatum::DataValueType::GlobeCoordinate',
      'monolingualtext': 'Wikidatum::DataValueType::MonolingualText',
      'novalue': 'Wikidatum::DataValueType::NoValue',
      'quantity': 'Wikidatum::DataValueType::Quantity',
      'somevalue': 'Wikidatum::DataValueType::SomeValue',
      'string': 'Wikidatum::DataValueType::WikibaseString',
      'time': 'Wikidatum::DataValueType::Time',
      'wikibase-item': 'Wikidatum::DataValueType::WikibaseItem'
    }.freeze
    # rubocop:enable Lint/SymbolConversion
  end
end
