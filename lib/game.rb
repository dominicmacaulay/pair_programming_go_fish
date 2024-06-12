# frozen_string_literal: true

require_relative 'deck'

# go fish game class
class Game
  attr_reader :deck_cards, :players, :winner, :deal_number

  def initialize(players, deck_cards: nil, deal_number: 5)
    @deal_number = deal_number
    @deck_cards = deck_cards
    @players = players
    @winner = nil
  end

  def deck
    @deck ||= deck_cards.nil? ? Deck.new : Deck.new(cards: deck_cards)
  end

  def start
    deck.shuffle
    deal_number.times do
      players.each { |player| player.add_to_hand(deck.deal) }
    end
  end
end
