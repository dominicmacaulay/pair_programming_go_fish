# frozen_string_literal: true

# socket runner for go fish
class SocketRunner
  attr_reader :game, :clients
  attr_accessor :info_shown, :rank, :rank_prompted, :opponent, :opponent_prompted

  def initialize(game:, clients:)
    @game = game
    @clients = clients
    @info_shown = false
    @rank = nil
    @rank_prompted = false
    @opponent = nil
    @opponent_prompted = false
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

    show_info
    return unless valid_rank?

    nil unless valid_opponent?
  end

  private

  def valid_opponent?
    return true unless opponent.nil?

    prompt_for_opponent
    input = receive_input(clients[game.current_player])
    return false if input.nil?

    valid_opponent_input?(input)
  end

  def valid_opponent_input?(input)
    message = game.match_player_name(input)
    if message.is_a?(String)
      send_message(clients[game.current_player], message)
      return false
    end
    self.opponent = message
    true
  end

  def prompt_for_opponent
    return if opponent_prompted == true

    send_message(clients[game.current_player], 'Please enter the opponent you would like to ask: ')
    self.opponent_prompted = true
  end

  def show_info # rubocop:disable Metrics/AbcSize
    return if info_shown == true

    hand = game.current_player.show_hand
    opponents = game.retrieve_opponents

    send_message(clients[game.current_player], opponents.display)
    send_message(clients[game.current_player], hand.display)
    self.info_shown = true
  end

  def valid_rank?
    return true unless rank.nil?

    prompt_for_rank
    input = receive_input(clients[game.current_player])
    return false if input.nil?

    valid_rank_input?(input)
  end

  def valid_rank_input?(input)
    message = game.validate_rank_choice(input)
    send_message(clients[game.current_player], message)
    if message.include?('acceptable')
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
    send_message(clients[current_player], message)
    message.include?('you received')
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
