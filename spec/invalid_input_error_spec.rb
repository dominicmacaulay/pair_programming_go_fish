# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/invalid_input_error'
require_relative '../lib/invalid_name_error'

RSpec.describe InvalidInputError do
  describe '==' do
    it 'returns true if all attributes are equal' do
      message1 = InvalidInputError.new('yes')
      message2 = InvalidInputError.new('yes')
      expect(message1).to eq message2
    end
    it 'returns false in any attributes are not equal' do
      message1 = InvalidInputError.new('yes')
      message2 = InvalidInputError.new('no')
      expect(message1).not_to eq message2
    end
  end
end

RSpec.describe InvalidNameError do
  describe 'display' do
    it 'returns an accurate message' do
      name = 'Joey'
      message = InvalidNameError.new(name)
      expect(message.display).to eql "'#{name}' is not a valid name. Try again:"
    end
  end
end
