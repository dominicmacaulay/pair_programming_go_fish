# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative 'spec_helper'

RSpec.describe Game do
  describe 'initialization' do
    it 'creates variables with correct values' do
      player1 = Player.new('Dom')
      player2 = Player.new('Josh')
      game = Game.new([player1, player2])
      expect(game.players).to eql([player1, player2])
      expect(game.winner).to be nil
      expect(game.deck).to respond_to(:cards)
    end
  end
end
