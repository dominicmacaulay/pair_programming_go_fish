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
end
