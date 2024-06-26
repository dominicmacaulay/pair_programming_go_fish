# frozen_string_literal: true

require 'socket'
require_relative 'player'
require_relative 'game'
require_relative 'socket_runner'
require_relative 'client'

# runs interactions between the clients and the server
class SocketServer
  attr_reader :players_per_game, :client_states, :clients_with_players, :port_number
  attr_accessor :send_awaiting_message, :games

  def initialize(players_per_game = 2, port_number = 3336)
    @port_number = port_number
    @players_per_game = players_per_game
    @client_states = {}
    @clients_with_players = {}
    @send_awaiting_message = true
    @games = []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server&.close
  end

  def accept_new_client
    client = @server.accept_nonblock
    create_client(client)
    self.send_awaiting_message = true
    puts 'Client: accepted.'
    client
  rescue IO::WaitReadable, Errno::EINTR
    await_message
  end

  def create_player_if_possible
    client_states.each do |client, state|
      next unless state == Client::STATES[:unnamed]

      name = retrieve_name(client)
      next if name.nil?

      make_player(client, name)
      client_states[client] = Client::STATES[:pending_ungreeted]
    end
  end

  def create_game_if_possible
    if pending_clients.count >= players_per_game
      games.push(Game.new(retrieve_players))
      games.last
    else
      send_ungreeted_players_message
      nil
    end
  end

  def run_game(game)
    create_runner(game).play_game
  end

  def create_runner(game)
    SocketRunner.new(game: game, clients: game_clients(game.players))
  end

  private

  def game_clients(players)
    clients_with_players.select do |client, player|
      players.include?(player)
    end.invert
  end

  def send_ungreeted_players_message
    client_states.each do |client, state|
      next unless state == Client::STATES[:pending_ungreeted]

      send_message(client, 'Waiting for other players to join...')
      client_states[client] = Client::STATES[:pending_greeted]
    end
  end

  def retrieve_players
    players = []
    pending_clients.each_key do |client|
      next unless clients_with_players.key?(client)

      client_states[client] = Client::STATES[:in_game]
      players << clients_with_players[client]
      return players if players.length == players_per_game
    end
  end

  def pending_clients
    client_states.select do |client, state|
      state == Client::STATES[:pending_greeted] || state == Client::STATES[:pending_ungreeted]
    end
  end

  def create_client(client)
    client_states[client] = Client::STATES[:unnamed]
    send_message(client, 'I (God) demand you give me a name. Enter it now: ')
  end

  def await_message
    return unless send_awaiting_message == true

    self.send_awaiting_message = false
    puts 'Awaiting clients'
  end

  def make_player(client, name)
    clients_with_players[client] = Player.new(name)
  end

  def retrieve_name(client)
    name = capture_client_input(client)

    return nil if name.nil?

    return put_client_in_their_place(client) if name.length < Player::MINIMUM_NAME_LENGTH

    name
  end

  def put_client_in_their_place(client)
    message = "I (God) do not approve of this name for it is not at
      least #{Player::MINIMUM_NAME_LENGTH} characters long. Do better: "

    send_message(client, message)
    nil
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
