# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/deck'

RSpec.describe Deck do
  describe 'initialize' do
    it 'should have the passed in cards if given' do
      deck = Deck.new(cards: [2])
      expect(deck.cards).to eql [2]
    end
    it 'should create a new standard deck if no cards are given' do
      standard_deck_length = 52
      deck = Deck.new
      expect(deck.cards.count).to eql standard_deck_length
    end
  end

  describe 'shuffle' do
    it 'should shuffle the deck' do
      deck1 = Deck.new
      deck2 = Deck.new
      expect(deck1.cards).to eql deck2.cards
      deck1.shuffle(Random.new(1000))
      expect(deck1.cards).not_to eq deck2.cards
    end
  end
end
