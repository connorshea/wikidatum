# frozen_string_literal: true

require_relative 'wikidatum/client'
require_relative 'wikidatum/data_value_type'
require_relative 'wikidatum/item'
require_relative 'wikidatum/qualifier'
require_relative 'wikidatum/reference'
require_relative 'wikidatum/sitelink'
require_relative 'wikidatum/snak'
require_relative 'wikidatum/statement'
require_relative 'wikidatum/term'
require_relative 'wikidatum/version'

module Wikidatum
  class Error < StandardError; end

  # These language codes are not enforced, you can pass whatever language code
  # you want, even if it's not represented in this list. The purpose of this
  # is to provide helper constants to allow writing more readable code.
  #
  # This will only cover some of the most common language codes, not all of
  # them.
  module LanguageCodes
    # rubocop:disable Naming/ConstantName
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
    DATA_VALUE_TYPES = {
      'monolingualtext': 'Wikidatum::DataValueType::MonolingualText',
      'novalue': 'Wikidatum::DataValueType::NoValue',
      'somevalue': 'Wikidatum::DataValueType::SomeValue',
      'string': 'Wikidatum::DataValueType::String',
      'time': 'Wikidatum::DataValueType::Time',
      'wikibase-entityid': 'Wikidatum::DataValueType::WikibaseEntityId'
    }.freeze
  end

end
