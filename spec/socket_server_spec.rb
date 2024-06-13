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
    sleep(0.1)
  end

  after(:each) do
    @server.stop
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  describe 'accept_new_client' do
    it 'adds the client to the unnamed_clients array' do
      expect(@server.unnamed_clients.length).to eql 0
      make_unnamed_client
      expect(@server.unnamed_clients.length).to eql 1
    end
    it 'prompts the client to enter their name' do
      client = make_unnamed_client
      expect(client.capture_output).to eql 'Enter your name: '
    end
  end

  describe 'create_player_if_possible' do
  end
end

def make_unnamed_client
  client = Client.new(@server.port_number)
  @server.accept_new_client
  client
end
