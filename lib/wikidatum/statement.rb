# frozen_string_literal: true

class Wikidatum::Statement
  # @return [String]
  attr_accessor :rank

  # @param rank [String] The rank of the given statement.
  #   Can have the values "preferred", "normal", or "deprecated". Defaults to "normal".
  def initialize(rank: 'normal')
    @rank = rank
  end
end
