# frozen_string_literal: true

# go fish deck class
class Deck
  attr_reader :cards

  def initialize(cards: make_cards)
    @cards = cards
  end

  def make_cards
  end
end
