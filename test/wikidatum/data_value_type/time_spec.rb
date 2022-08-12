# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::Time do
  describe 'creating a time' do
    it 'works' do
      time = Wikidatum::DataValueType::Time.new(
        time: '+2022-03-00T00:00:00Z',
        time_zone: 0,
        precision: 10,
        calendar_model: 'https://wikidata.org/wiki/Q123'
      )

      assert time.is_a?(Wikidatum::DataValueType::Time)
    end
  end

  describe '#pretty_precision' do
    it 'works for all 14 possible precisions' do
      (0..14).each do |precision|
        time = Wikidatum::DataValueType::Time.new(
          time: '+2022-03-00T00:00:00Z',
          time_zone: 0,
          precision: precision,
          calendar_model: 'https://wikidata.org/wiki/Q123'
        )

        assert time.pretty_precision.is_a?(Symbol)
      end
    end
  end
end
