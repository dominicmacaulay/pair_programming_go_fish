# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/error_message'
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
      expect(game.current_player).to eql(game.players.first)
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

  describe 'match_player_name' do
    it 'returns the player object that matches the given name' do
      name = player2.name
      return_value = game.match_player_name(name)
      expect(return_value).to eql player2
    end
    it 'returns an error message object if the name does not match to a player' do
      name = 'Steve'
      return_value = game.match_player_name(name)
      expect(return_value).to eq ErrorMessage.new(name: name)
    end
    it 'returns an error message object if the name only matches the current player' do
      name = game.current_player.name
      return_value = game.match_player_name(name)
      expect(return_value).to eq ErrorMessage.new(name: name)
    end
  end
end
