# frozen_string_literal: true

require_relative 'client'

puts 'Enter the server you would like to connect to: '
input = gets.chomp

port = input >= 4 ? input : 3336

client = Client.new(port)
loop do
  output = ''
  output = client.capture_output until output != ''
  if output.include?(':')
    print output
    client.provide_input(gets.chomp)
  else
    puts output
  end
end
