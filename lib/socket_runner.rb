# frozen_string_literal: true

# socket runner for go fish
class SocketRunner
  attr_reader :game, :clients

  def initialize(game:, clients:)
    @game = game
    @clients = clients
  end
end
