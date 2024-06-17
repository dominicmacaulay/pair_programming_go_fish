# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/player'
require_relative '../lib/card'
require_relative '../lib/show_info'

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

  describe 'remove_cards_with_rank' do
    let(:player) { Player.new('Dom') }
    let(:rank1) { 'Jack' }
    let(:rank2) { '5' }
    let(:card1) { Card.new(rank1, 'Diamonds') }
    let(:card2) { Card.new(rank1, 'Spades') }
    let(:card3) { Card.new(rank2, 'Spades') }
    before do
      player.add_to_hand([card1, card2, card3])
      @cards = player.remove_cards_with_rank(rank1)
    end
    it 'removes only the cards with the given rank' do
      expect(player.hand_has_rank?(rank1)).to be false
      expect(player.hand_has_rank?(rank2)).to be true
    end
    it 'returns the removed cards' do
      expect(@cards).to include(card1, card2)
      expect(@cards).not_to include(card3)
    end
  end

  describe 'rank_count' do
    it "returns the number of cards in the player's hand with the given rank" do
      player = Player.new('Dom')
      rank = '4'
      card1 = Card.new(rank, 'Hearts')
      card2 = Card.new(rank, 'Spades')
      card3 = Card.new('5', 'Clubs')
      player.add_to_hand([card1, card2, card3])
      expect(player.rank_count(rank)).to eql 2
    end
  end

  describe 'show_hand' do
    it 'returns message object' do
      player = Player.new('Dom', hand: [Card.new('4', 'Hearts')])
      expect(player.show_hand).to eq ShowInfo.new(cards: player.hand)
    end
  end

  describe 'make_book?' do
    before do
      @player = Player.new('Dom')
      @player.add_to_hand([Card.new('4', 'Hearts'), Card.new('4', 'Spades'), Card.new('4', 'Clubs'),
                           Card.new('4', 'diamonds')])
      @player.add_to_hand([Card.new('8', 'Hearts'), Card.new('8', 'Spades'), Card.new('8', 'Clubs'),
                           Card.new('8', 'diamonds')])
      @player.add_to_hand([Card.new('Jack', 'Hearts'), Card.new('Jack', 'Spades'), Card.new('Jack', 'Clubs'),
                           Card.new('Jack', 'diamonds')])
    end
    it 'makes a book and returns true if the player can make a book' do
      expect(@player.make_book?).to be true
      expect(@player.book_count).to eql 3
      expect(@player.hand_count).to eql 0
    end
    it 'does nothing and returns false if the player cannot make a book' do
      @player.make_book?
      @player.add_to_hand([Card.new('4', 'Hearts'), Card.new('4', 'Spades')])
      expect(@player.make_book?).to be false
      expect(@player.book_count).to eql 3
      expect(@player.hand_count).to eql 2
    end
  end

  describe 'total_book_value' do
    before do
      @player = Player.new('Dom')
      @player.add_to_hand([Card.new('4', 'Hearts'), Card.new('4', 'Spades'), Card.new('4', 'Clubs'),
                           Card.new('4', 'diamonds')])
      @player.add_to_hand([Card.new('8', 'Hearts'), Card.new('8', 'Spades'), Card.new('8', 'Clubs'),
                           Card.new('8', 'diamonds')])
      @player.add_to_hand([Card.new('Jack', 'Hearts'), Card.new('Jack', 'Spades'), Card.new('Jack', 'Clubs'),
                           Card.new('Jack', 'diamonds')])
    end
    it 'returns the total value of all of the books summed' do
      @player.make_book?
      book_value = @player.books[0].value + @player.books[1].value + @player.books[2].value
      expect(@player.total_book_value).to eql book_value
    end
  end
end
