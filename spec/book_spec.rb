# frozen_string_literal: true

require_relative '../lib/book'
require_relative '../lib/card'
require_relative 'spec_helper'

RSpec.describe Book do
  before do
    @card1 = Card.new('4', 'Spades')
    @card2 = Card.new('4', 'Hearts')
    @card3 = Card.new('4', 'Clubs')
    @card4 = Card.new('4', 'Diamonds')
    @book = Book.new([@card1, @card2, @card3, @card4])
  end
  it 'stores the given cards' do
    expect(@book.cards).to include(@card1, @card2, @card3, @card4)
  end
  it 'has an overal value based on the rank of each card' do
    expect(@book.value).to eq @card1.value
  end
end
