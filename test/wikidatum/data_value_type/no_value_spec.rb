# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::NoValue do
  it '.marshal_load' do
    # The value passed to marshal_load doesn't matter in this case.
    no_value = Wikidatum::DataValueType::NoValue.marshal_load(nil)

    assert no_value.is_a?(Wikidatum::DataValueType::Base)
  end
end
