# frozen_string_literal: true

# Error Message class
class InvalidInputError
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def display
    "#{input} is invalid!"
  end

  def ==(other)
    input == other.input
  end
end
