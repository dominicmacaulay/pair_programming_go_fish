# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/error_message'

RSpec.describe ErrorMessage do
  describe '==' do
    it 'returns true if all attributes are equal' do
      message1 = ErrorMessage.new
      message2 = ErrorMessage.new
      expect(message1).to eq message2
    end
    it 'returns false in any attributes are not equal' do
      message1 = ErrorMessage.new(name: 'Josh')
      message2 = ErrorMessage.new
      expect(message1).not_to eq message2
    end
  end

  describe 'name error message' do
    it 'returns a string indicating the given name is invalid' do
      name = 'Micah'
      result = ErrorMessage.new(name: name)
      result_message = result.display
      expect(result_message).to eql "'#{name}' is not a valid name. Try again: "
    end
  end
end
