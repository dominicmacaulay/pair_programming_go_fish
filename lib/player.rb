# frozen_string_literal: true

# go fish player class
class Player
  attr_reader :name, :hand, :books

  def initialize(name, hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end

  def add_to_hand(cards)
    hand.push(*cards)
  end

  def hand_count
    hand.count
  end
end
