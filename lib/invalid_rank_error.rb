# frozen_string_literal: true

require_relative 'invalid_input_error'

# class
class InvalidRankError < InvalidInputError
  def display
    "'#{input}' is not a valid rank. Try again:"
  end
end
