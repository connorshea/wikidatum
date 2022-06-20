# frozen_string_literal: true

require 'test_helper'

class TestWikidatumTerm < Minitest::Test
  def test_that_creating_a_term_works
    term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

    assert term.is_a?(Wikidatum::Term)
  end

  def test_that_creating_a_term_with_symbol_lang_works
    term = Wikidatum::Term.new(lang: :en, value: 'Foo bar')

    assert term.is_a?(Wikidatum::Term)
  end

  def test_lang_method
    term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

    assert term.lang.is_a?(String)
    assert_equal term.lang, 'en'
  end

  def test_lang_method_with_symbol
    term = Wikidatum::Term.new(lang: :en, value: 'Foo bar')

    assert term.lang.is_a?(String)
    assert_equal term.lang, 'en'
  end

  def test_value_method
    term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

    assert term.value.is_a?(String)
    assert_equal term.value, 'Foo bar'
  end
end
