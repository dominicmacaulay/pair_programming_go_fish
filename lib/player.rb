# frozen_string_literal: true

# go fish player class
class Player
  attr_reader :name, :hand, :books

  def initialize(name, hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end
end
