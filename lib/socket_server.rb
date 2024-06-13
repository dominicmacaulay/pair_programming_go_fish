# frozen_string_literal: true

require 'socket'

# runs interactions between the clients and the server
class SocketServer
  attr_reader :players_per_game, :client_states, :clients_with_players

  def initialize(players_per_game = 2)
    @players_per_game = players_per_game
    @client_states = {}
    @clients_with_players = {}
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
    client_states[client] = 'unnamed'
    send_message(client, 'I (God) demand you give me a name. Enter it now: ')
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'no client'
  end

  def create_player_if_possible
    client_states.each do |client, state|
      next unless state == 'unnamed'

      name = retrieve_name(client)
      make_player(client, name) unless name.nil?
    end
  end

  private

  def make_player(client, name)
    clients_with_players[client] = Player.new(name)
  end

  def retrieve_name(client)
    name = capture_client_input(client)

    return nil if name.nil?

    unless name.length < 3
      send_message(client, 'I (God) do not approve of this name. Do better: ')
      return nil
    end
    name
  end

  def capture_client_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    nil
  end

  def send_message(client, message)
    client.puts(message)
  end
end
