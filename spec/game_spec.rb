# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative 'spec_helper'

RSpec.describe Game do
  let(:player1) { Player.new('Dom') }
  let(:player2) { Player.new('Josh') }
  let(:game) { Game.new([player1, player2]) }
  describe 'initialization' do
    it 'creates variables with correct values' do
      expect(game.players).to eql([player1, player2])
      expect(game.winner).to be nil
      expect(game.deck).to respond_to(:cards)
    end
  end

  describe 'start' do
    it 'shuffles the deck' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end
    it 'deals each player the standard amount of cards' do
      expect(player1.hand).to be_empty
      expect(player2.hand).to be_empty
      game.start
      expect(player1.hand.count).to eql game.deal_number
      expect(player2.hand.count).to eql game.deal_number
    end
  end
end
