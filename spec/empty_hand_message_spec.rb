# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/empty_hand_message'

RSpec.describe EmptyHandMessage do
  describe 'display' do
    it 'shows message for empty deck' do
      expected_message = 'Sorry! The deck is empty. You are going to have to wait this one out.'
      message_object = EmptyHandMessage.new(deck_empty: true)
      expect(message_object.display).to eq expected_message
    end
    it 'shows message for player receiving cards' do
      expected_message = 'Your hand was empty, so you received cards from the pond.'
      message_object = EmptyHandMessage.new(got_cards: true)
      expect(message_object.display).to eq expected_message
    end
  end
  describe '==' do
    it 'returns true if attributes are the same' do
      object1 = EmptyHandMessage.new
      object2 = EmptyHandMessage.new
      expect(object1).to eq object2
    end
    it 'returns false if any attributes are not the same' do
      object1 = EmptyHandMessage.new(deck_empty: true)
      object2 = EmptyHandMessage.new(got_cards: true)
      expect(object1).not_to eq object2
    end
  end
end
