# frozen_string_literal: true

require_relative 'card'

# go fish deck class
class Deck
  attr_reader :cards

  def initialize(cards: make_cards)
    @cards = cards
  end

  def make_cards
    Card::SUITS.flat_map do |suit|
      Card::RANKS.map do |rank|
        Card.new(rank, suit)
      end
    end
  end
end
