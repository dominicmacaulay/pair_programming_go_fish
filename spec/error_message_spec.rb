# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/error_message'

RSpec.describe ErrorMessage do
  describe 'name error message' do
    it 'returns a string indicating the given name is invalid' do
      name = 'Micah'
      result = ErrorMessage.new(name: name)
      result_message = result.display
      expect(result_message).to eql "'#{name}' is not a valid name. Try again: "
    end
  end
end
