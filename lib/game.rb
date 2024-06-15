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

  def deal_to_player_if_necessary
    return nil unless current_player.hand_count.zero?

    if deck.cards_count.zero?
      @current_player = next_player
      return 'Sorry. Your hand is empty and there are no cards in the pond. You will have to sit this one out.'
    end
    deal_number.times { current_player.add_to_hand(deck.deal) }
    'Your hand was empty, but you received cards from the pond!'
  end

  def retrieve_opponents
    opponents = players.map { |player| player if player != current_player }.compact
    ShowInfo.new(opponents: opponents)
  end

  def validate_rank_choice(rank)
    return 'This is an acceptable choice.' if current_player.hand_has_rank?(rank)

    'You have chosen foolishly. Choose again: '
  end

  def match_player_name(name)
    named_player = players.detect do |player|
      player.name == name && player != current_player
    end
    named_player.nil? ? "Do you see '#{name}' among your opponents? Try again: " : named_player
  end

  def play_round(opponent, rank)
    run_transaction(opponent, rank)
  end

  private

  def next_player
    index = players.index(current_player)
    self.current_player = players[(index + 1) % players.count]
  end

  def run_transaction(opponent, rank)
    opponent_transaction(opponent, rank) if opponent.hand_has_rank?(rank)
  end

  def opponent_transaction(opponent, rank)
    cards = opponent.remove_cards_with_rank(rank)
    current_player.add_to_hand(cards)
  end
end
