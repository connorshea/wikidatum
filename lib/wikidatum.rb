# frozen_string_literal: true

require 'wikidatum/client'
require 'wikidatum/data_type'
require 'wikidatum/error'
require 'wikidatum/errors'
require 'wikidatum/item'
require 'wikidatum/qualifier'
require 'wikidatum/reference'
require 'wikidatum/reference_part'
require 'wikidatum/sitelink'
require 'wikidatum/statement'
require 'wikidatum/term'
require 'wikidatum/utils'
require 'wikidatum/version'

module Wikidatum
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

  module DataType
    # rubocop:disable Lint/SymbolConversion
    DATA_TYPES = {
      'commonsMedia': 'Wikidatum::DataType::CommonsMedia',
      'external-id': 'Wikidatum::DataType::ExternalId',
      'globe-coordinate': 'Wikidatum::DataType::GlobeCoordinate',
      'monolingualtext': 'Wikidatum::DataType::MonolingualText',
      'novalue': 'Wikidatum::DataType::NoValue',
      'quantity': 'Wikidatum::DataType::Quantity',
      'somevalue': 'Wikidatum::DataType::SomeValue',
      'string': 'Wikidatum::DataType::WikibaseString',
      'time': 'Wikidatum::DataType::Time',
      'url': 'Wikidatum::DataType::WikibaseUrl',
      'wikibase-item': 'Wikidatum::DataType::WikibaseItem'
    }.freeze
    # rubocop:enable Lint/SymbolConversion
  end
end
