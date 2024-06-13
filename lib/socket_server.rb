# frozen_string_literal: true

require 'socket'

# runs interactions between the clients and the server
class SocketServer
  attr_reader :players_per_game, :unnamed_clients

  def initialize(players_per_game = 2)
    @players_per_game = players_per_game
    @unnamed_clients = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server&.close
  end

  def accept_new_client
    client = @server.accept_nonblock
    unnamed_clients << client
    send_message(client, 'Enter your name: ')
  rescue IO::WaitReadable, Errno::EINTR
    puts 'no client'
  end

  private

  def send_message(client, message)
    client.puts(message)
  end
end
