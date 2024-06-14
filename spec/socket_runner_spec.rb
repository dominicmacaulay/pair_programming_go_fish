# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/socket_runner'
require_relative '../lib/socket_server'
require_relative '../lib/client'

RSpec.describe SocketRunner do
  describe 'play_round' do
    describe 'draw if necessary' do
      before do
        @client1.capture_output
        @client2.capture_output
      end
      it 'should send a message and return immediately if the player cannot play' do
        @game.deck.clear_cards
        @runner.play_round
        expect(@current_player.capture_output).to match 'Sorry'
        expect(@game.current_player.name).to eql @client2_name
      end
      it 'should send a message if the player received cards from the pond' do
        @runner.play_round
        expect(@current_player.capture_output).to match 'you received'
      end

      fit 'should display the player their hand and opponents' do
        @runner.play_round
        expect(@client1.capture_output).to include('You have')
      end

      fit 'should display the player their hand and opponents' do
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
        expect(@current_player.capture_output).to eql ''
      end
      it 'returns nil if the player has not given a rank and sends a message for an invalid rank' do
        expect(@runner.play_round).to be nil
        @current_player.provide_input('15')
        @runner.play_round
        expect(@current_player.capture_output).to match('not a valid rank')
      end
      it 'returns an acceptance message and sets the state varaible if rank is valid' do
        @game.current_player.add_to_hand(Card.new('3', 'Hearts'))
        @current_player.provide_input('3')
        @runner.play_round
        expect(@current_player.capture_output).to match('acceptable')
        expect(@runner.rank).to eql '3'
      end
    end
  end

  before do
    @server = SocketServer.new
    @server.start
    sleep(0.1)

    create_clients

    @game = @server.create_game_if_possible
    @runner = @server.create_runner(@game)

    @client1.capture_output
    @client2.capture_output
    @current_player = get_current_player
  end

  def create_clients
    @client1_name = 'Dom'
    @client2_name = 'Josh'
    @client1 = create_client(@client1_name)
    @client2 = create_client(@client2_name)
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

    @client2
  end

  after do
    @server.stop
    @client1.close
    @client2.close
  end
end
