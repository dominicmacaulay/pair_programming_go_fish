# frozen_string_literal: true

# Error Message class
class ErrorMessage
  attr_reader :name

  def initialize(name: false)
    @name = name
  end

  def display
    name_message unless name == false
  end

  private

  def name_message
    "'#{name}' is not a valid name. Try again: "
  end
end
