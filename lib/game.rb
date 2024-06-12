# frozen_string_literal: true

require_relative 'deck'

# go fish game class
class Game
  attr_reader :deck_cards, :players, :winner

  def initialize(players, deck_cards: nil)
    @deck_cards = deck_cards
    @players = players
    @winner = nil
  end

  def deck
    @deck ||= Deck.new(cards: deck_cards)
  end
end
