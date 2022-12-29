# frozen_string_literal: true

require 'test_helper'

describe Wikidatum::DataType::SomeValue do
  it '.marshal_load' do
    # The value passed to marshal_load doesn't matter in this case.
    some_value = Wikidatum::DataType::SomeValue.marshal_load(nil)

    assert some_value.is_a?(Wikidatum::DataType::Base)
  end
end
