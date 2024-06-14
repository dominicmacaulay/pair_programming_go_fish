# frozen_string_literal: true

require 'spec_helper'
require 'socket'
require_relative '../lib/socket_server'
require_relative '../lib/game'
require_relative '../lib/client'

RSpec.describe SocketServer do
  before(:each) do
    @server = SocketServer.new
    @server.start
    @clients = []
    sleep(0.1)
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  describe 'accept_new_client' do
    it 'adds the client to the client_states hash with unnamed value' do
      server_client = make_unnamed_client
      expect(@server.client_states[server_client]).to eql Client::STATES[:unnamed]
    end
    it 'prompts the client to enter their name' do
      make_unnamed_client
      expect(@clients.first.capture_output).to eql 'I (God) demand you give me a name. Enter it now: '
    end
  end

  describe 'create_player_if_possible' do
    it 'adds client to clients hash and changes state to waiting if name is provided' do
      server_client = make_unnamed_client
      @clients.first.provide_input('Dom')
      @server.create_player_if_possible
      expect(@server.clients_with_players[server_client]).to respond_to(:hand)
      expect(@server.client_states[server_client]).to eql Client::STATES[:pending_ungreeted]
    end
    it 'does not add client to clients hash or change state if name is provided' do
      server_client = make_unnamed_client
      @server.create_player_if_possible
      expect(@server.clients_with_players.count).to eql 0
      expect(@server.client_states[server_client]).to eql Client::STATES[:unnamed]
    end
  end

  describe 'create_game_if_possible' do
    it 'creates a game if there are enough players' do
      make_full_client('P 1')
      make_full_client('P 2')
      @server.create_game_if_possible
      expect(@server.games.length).to eql 1
    end
    it 'does not create a game if there are not enough pending players' do
      make_full_client('P 1')
      make_full_client('P 2')
      make_full_client('P 3')
      @server.create_game_if_possible
      @server.create_game_if_possible
      expect(@server.games.length).not_to eql 2
    end
    it 'sends waiting players a message when there are not enough to make a game' do
      make_full_client('P 1')
      @clients.first.capture_output
      @server.create_game_if_possible
      expect(@clients.first.capture_output).to match 'Waiting'
    end
    it 'sends waiting message only once' do
      make_full_client('P 1')
      @server.create_game_if_possible
      @clients.first.capture_output
      @server.create_game_if_possible
      expect(@clients.first.capture_output).to eql ''
    end
    it 'does not send waiting message to players in a game' do
      make_full_client('P 1')
      @server.create_game_if_possible
      expect(@clients.first.capture_output).to match 'Waiting'
      make_full_client('P 2')
      @server.create_game_if_possible
      expect(@clients.first.capture_output).not_to match 'Waiting'
    end
  end
end

def make_unnamed_client
  client = Client.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
end

def make_full_client(name)
  client = Client.new(@server.port_number)
  @clients.push(client)
  server_client = @server.accept_new_client
  @clients.last.provide_input(name)
  @server.create_player_if_possible
  server_client
end
