# frozen_string_literal: true

# empty hand message class
class EmptyHandMessage
  attr_reader :deck_empty, :got_cards

  def initialize(deck_empty: false, got_cards: false)
    @deck_empty = deck_empty
    @got_cards = got_cards
  end

  def display
    return empty_deck_message if deck_empty == true

    got_cards_message if got_cards == true
  end

  def ==(other)
    return false unless other.deck_empty == deck_empty
    return false unless other.got_cards == got_cards

    true
  end

  private

  def got_cards_message
    'Your hand was empty, so you received cards from the pond.'
  end

  def empty_deck_message
    'Sorry! The deck is empty. You are going to have to wait this one out.'
  end
end
