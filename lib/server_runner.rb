# frozen_string_literal: true

# lib/war_socket_server_runner.rb

require_relative 'socket_server'

puts 'How many players per game?'

input = gets.chomp.to_i

server = input <= 2 ? SocketServer.new : SocketServer.new(input)

server.start
loop do
  server.accept_new_client
  server.create_player_if_possible
  game = server.create_game_if_possible
  server.run_game(game) if game
  begin
  rescue StandardError
    server.stop
  end
end
