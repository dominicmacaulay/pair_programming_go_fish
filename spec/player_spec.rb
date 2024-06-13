# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/player'
require_relative '../lib/card'

RSpec.describe Player do
  describe 'initialize' do
    it 'should have the name it is given' do
      player1 = Player.new('Dom')
      player2 = Player.new('Josh')
      expect(player1.name).to eql 'Dom'
      expect(player2.name).to eql 'Josh'
    end
  end

  describe 'add_to_hand' do
    it "should add the given cards to the player's hand" do
      player = Player.new('Dom')
      card1 = Card.new('4', 'Hearts')
      card2 = Card.new('5', 'Spades')
      player.add_to_hand([card1, card2])
      expect(player.hand_count).to be 2
      expect(player.hand).to include(card1, card2)
    end
  end
end
