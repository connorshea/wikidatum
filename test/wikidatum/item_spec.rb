# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::Item do
  # Convenience method for loading Wikidatum::Item from a JSON fixture.
  def fixture_item(json_filename)
    Wikidatum::Item.marshal_load(JSON.parse(File.read("test/fixtures/#{json_filename}.json")))
  end

  describe '.marshal_load' do
    it 'works with an item that has many types of datavalues' do
      item = Wikidatum::Item.marshal_load(JSON.parse(File.read('test/fixtures/q123.json')))
      assert_kind_of Wikidatum::Item, item
    end
  end

  describe '#to_h' do
    it 'works with an item that has many types of datavalues' do
      item = fixture_item('q123')
      assert_kind_of Hash, item.to_h
    end
  end

  describe '#inspect' do
    it 'works with an item that has many types of datavalues' do
      item = fixture_item('q123')
      assert_kind_of String, item.inspect
    end
  end

  describe '#description' do
    it 'works with a string language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').description(lang: 'en')
    end

    it 'works with a symbol language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').description(lang: :en)
    end
  end

  describe '#descriptions' do
    it 'works with no language codes' do
      assert(fixture_item('q123').descriptions.all? { |desc| desc.is_a?(Wikidatum::Term) })
    end

    it 'works with a string language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').descriptions(langs: ['en']).first
    end

    it 'works with a symbol language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').descriptions(langs: [:en]).first
    end
  end

  describe '#label' do
    it 'works with a string language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').label(lang: 'en')
    end

    it 'works with a symbol language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').label(lang: :en)
    end
  end

  describe '#labels' do
    it 'works with no language codes' do
      assert(fixture_item('q123').labels.all? { |label| label.is_a?(Wikidatum::Term) })
    end

    it 'works with a string language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').labels(langs: ['en']).first
    end

    it 'works with a symbol language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').labels(langs: [:en]).first
    end
  end

  describe '#aliases' do
    it 'works with no language codes' do
      assert(fixture_item('q123').aliases.all? { |al| al.is_a?(Wikidatum::Term) })
    end

    it 'works with a string language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').aliases(langs: ['en']).first
    end

    it 'works with a symbol language code' do
      assert_kind_of Wikidatum::Term, fixture_item('q123').aliases(langs: [:en]).first
    end
  end

  describe '#sitelink' do
    it 'works with no sitenames' do
      assert(fixture_item('q123').sitelinks.all? { |sitelink| sitelink.is_a?(Wikidatum::Sitelink) })
    end

    it 'works with a string sitename' do
      assert_kind_of Wikidatum::Sitelink, fixture_item('q123').sitelinks(sites: ['enwiki']).first
    end

    it 'works with a symbol sitename' do
      assert_kind_of Wikidatum::Sitelink, fixture_item('q123').sitelinks(sites: [:enwiki]).first
    end
  end

  describe '#sitelink' do
    it 'works with a string sitename' do
      assert_kind_of Wikidatum::Sitelink, fixture_item('q123').sitelink(site: 'enwiki')
    end

    it 'works with a symbol sitename' do
      assert_kind_of Wikidatum::Sitelink, fixture_item('q123').sitelink(site: :enwiki)
    end
  end
end
