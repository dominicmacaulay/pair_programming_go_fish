# frozen_string_literal: true

require_relative 'invalid_input_error'

# name error class
class InvalidNameError < InvalidInputError
  def display
    "'#{input}' is not a valid name. Try again:"
  end
end
