# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/socket_runner'
require_relative '../lib/socket_server'
require_relative '../lib/client'

RSpec.describe SocketRunner do
  describe 'play_round' do
    before do
      @server = SocketServer.new(3)
      @server.start
      sleep(0.2)

      create_clients

      @game = @server.create_game_if_possible
      @runner = @server.create_runner(@game)

      @current_player = get_current_player
    end

    describe 'draw if necessary' do
      before do
        @client1.capture_output
        @client2.capture_output
      end
      it 'should send a message and return immediately if the player cannot play' do
        @game.deck.clear_cards
        expect(@runner.play_round).to be nil
        expect(@current_player.capture_output).to match 'Sorry'
        expect(@game.current_player.name).to eql @client2_name
      end
      it 'should send a message if the player received cards from the pond' do
        @runner.play_round
        expect(@current_player.capture_output).to match 'you received'
      end

      it 'should display the player their hand and opponents' do
        @runner.play_round
        expect(@client1.capture_output).to include('You have')
      end

      it 'should display the player their hand and opponents' do
        @runner.play_round
        expect(@client1.capture_output).to include('Your opponents')
      end
    end
    describe 'first ensures that the player has given a valid rank' do
      before do
        @game.start
      end
      it 'prompts the client to enter a rank once' do
        @runner.play_round
        expect(@current_player.capture_output).to match 'rank'
        @runner.play_round
        expect(@current_player.capture_output).not_to match 'rank'
      end
      it 'returns nil if the player has not given a rank and sends a message for an invalid rank' do
        expect(@runner.play_round).to be nil
        @current_player.provide_input('15')
        expect(@runner.play_round).to be nil
        expect(@current_player.capture_output).to match('foolishly')
        expect(@runner.rank).to be nil
      end
      it 'returns an acceptance message and sets the state variable if rank is valid' do
        @game.current_player.add_to_hand(Card.new('3', 'Hearts'))
        @current_player.provide_input('3')
        @runner.play_round
        expect(@current_player.capture_output).to match('acceptable')
        expect(@runner.rank).to eql '3'
      end
    end
    describe 'ensures that the player has given a valid opponent' do
      before do
        @game.current_player.add_to_hand(Card.new('3', 'Hearts'))
        @current_player.provide_input('3')
      end
      it 'prompts the client to enter an opponent once' do
        @runner.play_round
        expect(@current_player.capture_output).to match 'enter the opponent'
        @runner.play_round
        expect(@current_player.capture_output).not_to match 'enter the opponent'
      end
      it 'returns false if the client does not enter an opponent' do
        expect(@runner.play_round).to be nil
      end
      it 'returns false if the client provides invalid input and sends the client a message' do
        @runner.play_round
        @current_player.provide_input('madfa')
        expect(@runner.play_round).to be nil
        expect(@runner.opponent).to be nil
        expect(@current_player.capture_output).to match 'among your opponents'
      end
      it 'accepts valid player input and sends the message for the game result' do
        @runner.play_round
        @current_player.provide_input('Josh')
        expect(@runner.play_round)
        expect(@current_player.capture_output).to match 'You asked'
      end
    end
    describe 'displays round results to every player in the game' do
      before do
        @game.current_player.add_to_hand(Card.new('3', 'Hearts'))
        @current_player.provide_input('3')
        @runner.play_round
        @current_player.provide_input('Josh')
      end
      it 'returns correct message to each player' do
        @runner.play_round
        expect(@client1.capture_output).to match 'You asked'
        expect(@client2.capture_output).to match 'asked you'
        expect(@client3.capture_output).to match 'Dom asked'
      end
      it 'resets all variables at the end of a full game_round' do
        @runner.play_round
        expect(@runner.info_shown).to be false
        expect(@runner.rank).to be nil
        expect(@runner.rank_prompted).to be false
        expect(@runner.opponent).to be nil
        expect(@runner.opponent_prompted).to be false
      end
    end
  end

  def create_clients
    @client1_name = 'Dom'
    @client2_name = 'Josh'
    @client3_name = 'Micah'
    @client1 = create_client(@client1_name)
    @client2 = create_client(@client2_name)
    @client3 = create_client(@client3_name)
  end

  def create_client(name)
    client = Client.new(@server.port_number)
    @server.accept_new_client
    client.provide_input(name)
    @server.create_player_if_possible
    client
  end

  def get_current_player # rubocop:disable Naming/AccessorMethodName
    return @client1 if @client1_name == @game.current_player.name
    return @client2 if @client2_name == @game.current_player.name

    @client3
  end

  after do
    @server.stop
    @client1.close
    @client2.close
  end
end
