# frozen_string_literal: true

# socket runner for go fish
class SocketRunner
  attr_reader :game, :clients

  def initialize(game:, clients:)
    @game = game
    @clients = clients
  end

  def play_game
    game.start

    play_round until game.winner

    winner_message = game.display_winner
    @clients.each_value { |client| send_message(client, winner_message) }
  end

  def play_round
  end

  private

  def send_message(client, message)
    client.puts(message)
  end
end
