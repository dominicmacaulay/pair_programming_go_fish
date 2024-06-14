# frozen_string_literal: true

# socket runner for go fish
class SocketRunner
  attr_reader :game, :clients
  attr_accessor :rank, :rank_prompted

  def initialize(game:, clients:)
    @game = game
    @clients = clients
    @rank = nil
    @rank_prompted = false
  end

  def play_game
    game.start

    @clients.each_value { |client| send_message(client, 'Welcome to Go Fish!') }

    play_round until game.winner

    winner_message = game.display_winner
    @clients.each_value { |client| send_message(client, winner_message) }
  end

  def play_round
    return unless player_can_play?(game.current_player.dup)

    nil unless valid_rank?
  end

  private

  def valid_rank?
    prompt_for_rank
    input = receive_input(clients[game.current_player])
    return false if input.nil?

    valid_input?(input)
  end

  def valid_input?(input)
    message = game.validate_rank_choice(input)
    send_message(clients[game.current_player], message.display)
    if message.display.include?('acceptable')
      self.rank = input
      return true
    end
    false
  end

  def prompt_for_rank
    return unless rank_prompted == false

    send_message(clients[game.current_player], 'Please enter the rank you would like to ask for: ')
    self.rank_prompted = true
  end

  def player_can_play?(player)
    message = game.deal_to_player_if_necessary
    return true if message.nil?

    current_player = game.players.detect { |game_player| game_player.name == player.name }
    send_message(clients[current_player], message.display)
    message.display.include?('took cards')
  end

  def send_message(client, message)
    client.puts(message)
  end

  def receive_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    nil
  end
end
