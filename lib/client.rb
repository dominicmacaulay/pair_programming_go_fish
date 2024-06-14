# frozen_string_literal: true

require 'socket'

# client object
class Client
  STATES = {
    unnamed: 'unnamed',
    pending_ungreeted: 'pending ungreeted',
    pending_greeted: 'pending greeted',
    in_game: 'in game'
  }.freeze
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket&.close
  end
end
