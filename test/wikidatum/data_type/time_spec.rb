# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::Time do
  describe 'creating a DataType::Time' do
    it 'works' do
      time = Wikidatum::DataType::Time.new(
        time: '+2022-03-00T00:00:00Z',
        precision: 10,
        calendar_model: 'https://wikidata.org/wiki/Q123'
      )

      assert time.is_a?(Wikidatum::DataType::Time)
    end
  end

  describe '#pretty_precision' do
    it 'works for all 14 possible precisions' do
      (0..14).each do |precision|
        time = Wikidatum::DataType::Time.new(
          time: '+2022-03-00T00:00:00Z',
          precision: precision,
          calendar_model: 'https://wikidata.org/wiki/Q123'
        )

        assert time.pretty_precision.is_a?(Symbol)
      end
    end
  end
end
