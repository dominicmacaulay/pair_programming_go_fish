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

  describe 'hand_has_rank?' do
    let(:player) { Player.new('Dom') }
    it 'returns true if rank exists in hand' do
      player.add_to_hand(Card.new('4', 'Hearts'))
      expect(player.hand_has_rank?('4')).to be true
    end
    it 'returns false if rank does not exist in hand' do
      player.add_to_hand(Card.new('4', 'Hearts'))
      expect(player.hand_has_rank?('5')).to be false
    end
  end
end
