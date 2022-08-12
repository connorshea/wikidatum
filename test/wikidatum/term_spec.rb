# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::Term do
  describe 'creating a term' do
    it 'works' do
      term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

      assert term.is_a?(Wikidatum::Term)
    end

    it 'works with a symbol lang' do
      term = Wikidatum::Term.new(lang: :en, value: 'Foo bar')

      assert term.is_a?(Wikidatum::Term)
    end
  end

  describe '#lang' do
    it 'works' do
      term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

      assert term.lang.is_a?(String)
      assert_equal term.lang, 'en'
    end

    it 'works with a symbol' do
      term = Wikidatum::Term.new(lang: :en, value: 'Foo bar')

      assert term.lang.is_a?(String)
      assert_equal term.lang, 'en'
    end
  end

  describe '#value' do
    it 'works' do
      term = Wikidatum::Term.new(lang: 'en', value: 'Foo bar')

      assert term.value.is_a?(String)
      assert_equal term.value, 'Foo bar'
    end
  end
end
