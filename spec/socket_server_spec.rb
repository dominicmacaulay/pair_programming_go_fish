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
end

def make_unnamed_client
  client = Client.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
end
