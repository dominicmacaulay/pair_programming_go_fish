# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/round_result'
require_relative '../lib/player'

RSpec.describe RoundResult do
  before do
    @player1 = Player.new('P1')
    @player2 = Player.new('P2')
    @player3 = Player.new('P3')
  end

  describe '#==' do
    it 'returns true if the stored strings are the same' do
      result1 = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: false, got_rank: true,
                                card_gotten: '2', amount: 'two', empty_pond: true)
      result2 = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: false, got_rank: true,
                                card_gotten: '2', amount: 'two', empty_pond: true)
      expect(result1).to eq result2
    end
    it 'returns false if the stored string are not the same' do
      result1 = RoundResult.new(player: @player1, opponent: @player2, rank: '2')
      result2 = RoundResult.new(player: @player3, opponent: @player2, rank: '2')
      expect(result1).not_to eq result2
    end
  end

  describe '#display' do
    describe 'for the current_player' do
      it 'gets rank from opponent' do
        # given
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', got_rank: true, amount: 'two')
        # when
        result_message = result.display_for(@player1)
        # then
        expect(result_message).to eql "You asked P2 for 2's and got two of them."
      end
      it 'gets rank from pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, got_rank: true)
        result_message = result.display_for(@player1)
        expect(result_message).to eql "You asked P2 for 2's and went fishing and got one of them."
      end
      it 'does not get rank from the pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, card_gotten: '4')
        result_message = result.display_for(@player1)
        expect(result_message).to eql "You asked P2 for 2's and went fishing and got a 4."
      end
      it 'does not get anything' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, empty_pond: true)
        result_message = result.display_for(@player1)
        expect(result_message).to eql "You asked P2 for 2's and went fishing and got nothing! The pond is empty."
      end
    end

    describe 'for the opponent' do
      it 'gets rank from opponent' do
        # given
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', got_rank: true, amount: 'two')
        # when
        result_message = result.display_for(@player2)
        # then
        expect(result_message).to eql "P1 asked you for 2's and got two of them."
      end
      it 'gets rank from pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, got_rank: true)
        result_message = result.display_for(@player2)
        expect(result_message).to eql "P1 asked you for 2's and went fishing and got one of them."
      end
      it 'does not get rank from the pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, card_gotten: '4')
        result_message = result.display_for(@player2)
        expect(result_message).to eql "P1 asked you for 2's and went fishing and had no luck."
      end
      it 'does not get anything' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, empty_pond: true)
        result_message = result.display_for(@player2)
        expect(result_message).to eql "P1 asked you for 2's and went fishing and got nothing! The pond is empty."
      end
    end

    describe 'for any other players' do
      it 'gets rank from opponent' do
        # given
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', got_rank: true, amount: 'two')
        # when
        result_message = result.display_for(@player3)
        # then
        expect(result_message).to eql "P1 asked P2 for 2's and got two of them."
      end
      it 'gets rank from pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, got_rank: true)
        result_message = result.display_for(@player3)
        expect(result_message).to eql "P1 asked P2 for 2's and went fishing and got one of them."
      end
      it 'does not get rank from the pond' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, card_gotten: '4')
        result_message = result.display_for(@player3)
        expect(result_message).to eql "P1 asked P2 for 2's and went fishing and had no luck."
      end
      it 'does not get anything' do
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', fished: true, empty_pond: true)
        result_message = result.display_for(@player3)
        expect(result_message).to eql "P1 asked P2 for 2's and went fishing and got nothing! The pond is empty."
      end
    end
    describe 'concats the books made message if its true' do
      it 'does not concat if variable is false' do
        # given
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', got_rank: true, amount: 'two')
        # when
        result_message = result.display_for(@player1)
        # then
        expect(result_message).to eql "You asked P2 for 2's and got two of them."
      end
      it 'does concat if varialbe is true' do
        # given
        result = RoundResult.new(player: @player1, opponent: @player2, rank: '2', got_rank: true, amount: 'two')
        result.book_was_made
        # when
        result_message = result.display_for(@player1)
        # then
        expect(result_message).to eql "You asked P2 for 2's and got two of them, then created a book with them."
      end
    end
  end
end
