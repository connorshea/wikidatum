# frozen_string_literal: true

require "test_helper"

describe Wikidatum::VERSION do
  it 'has a version number' do
    refute_nil ::Wikidatum::VERSION
  end
end
