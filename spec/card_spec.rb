# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  let(:card) { Card.new('4', 'Hearts') }

  describe 'attributes' do
    it 'should have given attributes' do
      expect(card.rank).to eql '4'
      expect(card.suit).to eql 'Hearts'
    end
    it 'should have a value' do
      index_of_number_four = 2
      expect(card.value).to eql index_of_number_four
    end
  end
end
