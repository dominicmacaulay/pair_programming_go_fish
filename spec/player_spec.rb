# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/player'

RSpec.describe Player do
  describe 'initialize' do
    it 'should have the name it is given' do
      player1 = Player.new('Dom')
      player2 = Player.new('Josh')
      expect(player1.name).to eql 'Dom'
      expect(player2.name).to eql 'Josh'
    end
  end
end
