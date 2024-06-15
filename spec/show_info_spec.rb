# frozen_string_literal: true

require_relative '../lib/show_info'
require_relative '../lib/card'
require_relative '../lib/player'
require_relative 'spec_helper'

RSpec.describe ShowInfo do
  describe 'show cards' do
    it 'should return a string when given cards' do
      info = ShowInfo.new(cards: [Card.new('4', 'Hearts'), Card.new('3', 'Spades'), Card.new('5', 'Clubs')])
      expected_result = 'You have a 4 of Hearts, a 3 of Spades, and a 5 of Clubs'
      result = info.display
      expect(result).to eql expected_result
    end
  end
  describe 'show opponents' do
    it 'should return a string when given opponents' do
      info = ShowInfo.new(opponents: [Player.new('Dom'), Player.new('Josh'), Player.new('Micah')])
      expected_result = 'Your opponents are Dom, Josh, and Micah'
      result = info.display
      expect(result).to eql expected_result
    end
  end
  describe '#==' do
    it 'should return true if attributes are equal' do
      info1 = ShowInfo.new
      info2 = ShowInfo.new
      expect(info1).to eq info2
    end

    it 'should return false if players are different' do
      info1 = ShowInfo.new
      info2 = ShowInfo.new(cards: true)
      info3 = ShowInfo.new(opponents: true)
      expect(info1).not_to eq info2
      expect(info1).not_to eq info3
      expect(info2).not_to eq info3
    end
  end
end
