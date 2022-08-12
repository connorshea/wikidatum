# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataValueType::SomeValue do
  it '.marshal_load' do
    # The value passed to marshal_load doesn't matter in this case.
    some_value = Wikidatum::DataValueType::SomeValue.marshal_load(nil)

    assert some_value.is_a?(Wikidatum::DataValueType::Base)
  end
end
