# frozen_string_literal: true

# name error class
class InvalidNameError < InvalidInputError
  def display
    "'#{input}' is not a valid name. Try again:"
  end
end
