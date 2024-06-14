# frozen_string_literal: true

class ConfirmationMessage # rubocop:disable Style/Documentation
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def display
    "'#{input}' is... acceptable."
  end

  def ==(other)
    return false unless input == other.input

    true
  end
end
