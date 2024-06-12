# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  let(:card) { Card.new('4', 'Hearts') }

  describe 'attributes' do
    it 'should have given attributes' do
      expect(card.rank).to eql '4'
      expect(card.suit).to eql 'Hearts'
    end
    it 'should have a value' do
      index_of_number_four = 2
      expect(card.value).to eql index_of_number_four
    end
  end

  describe 'equal_rank?' do
    it 'should return true if the ranks are equal' do
      other_card = Card.new('4', 'Spades')
      expect(card.equal_rank?(other_card)).to be true
    end
    it 'should return false if the ranks are not equal' do
      other_card = Card.new('5', 'Hearts')
      expect(card.equal_rank?(other_card)).to be false
    end
  end

  describe '==' do
    it 'should return true if the rank and suit are equal' do
      other_card = Card.new('4', 'Hearts')
      expect(card).to eq other_card
    end
    it 'should return false if either the rank or suit are not equal' do
      other_card1 = Card.new('4', 'Spades')
      other_card2 = Card.new('5', 'Hearts')
      expect(card).not_to eq other_card1
      expect(card).not_to eq other_card2
    end
  end
end
