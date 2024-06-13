# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/error_message'

RSpec.describe ErrorMessage do
  describe 'name error message' do
    it 'returns a string indicating the given name is invalid' do
      result = ErrorMessage.new(name: true)
      result_message = result.display
      expect(result_message).to eql 'The name you selected is invalid... Try again: '
    end
  end
end
