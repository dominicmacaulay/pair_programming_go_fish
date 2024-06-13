# frozen_string_literal: true

require_relative 'deck'

# go fish game class
class Game
  attr_reader :deck_cards, :players, :winner, :deal_number
  attr_accessor :current_player

  def initialize(players, deck_cards: nil, deal_number: 5)
    @deal_number = deal_number
    @deck_cards = deck_cards
    @players = players
    @winner = nil
    @current_player = players.first
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

  def valid_rank_choice?(rank)
    current_player.hand_has_rank?(rank)
  end

  def match_player_name(name)
    named_player = players.detect do |player|
      player.name == name && player != current_player
    end
    named_player.nil? ? ErrorMessage.new(name: name) : named_player
  end
end
