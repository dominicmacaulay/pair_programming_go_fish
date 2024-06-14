require_relative '../lib/show_info'

RSpec.describe ShowInfo do
  let(:cards1) { [Card.new('2', 'Hearts'), Card.new('3', 'Hearts')] }
  let(:opponents1) { [Player.new('Someone'), Player.new('Someoneelse')] }
  let(:show_info1) { ShowInfo.new(cards: cards1, opponents: opponents1) }

  let(:cards2) { [Card.new('2', 'Hearts'), Card.new('4', 'Hearts')] }
  let(:opponents2) { [Player.new('Someone'), Player.new('Someoneelse')] }
  let(:show_info2) { ShowInfo.new(cards: cards2, opponents: opponents2) }

  let(:cards3) { [Card.new('2', 'Hearts'), Card.new('3', 'Hearts')] }
  let(:opponents3) { [Player.new('player1'), Player.new('player2')] }
  let(:show_info3) { ShowInfo.new(cards: cards3, opponents: opponents3) }

  let(:cards4) { [Card.new('2', 'Hearts'), Card.new('3', 'Hearts')] }
  let(:opponents4) { [Player.new('Someone'), Player.new('Someoneelse')] }
  let(:show_info4) { ShowInfo.new(cards: cards4, opponents: opponents1) }

  describe '#==' do
    it 'should return false if cards are different' do
      expect(show_info1 == show_info2).to be false
    end

    it 'should return false if players are different' do
      expect(show_info1 == show_info3).to be false
    end

    it 'should return true if players and cards are the same' do
      expect(show_info1 == show_info4).to be true
    end
  end
end
