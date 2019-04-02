require 'spec_helper'
require_relative '../lib/deck'

RSpec.describe Deck do
  before do
    @deck = Deck.new
  end

  it 'has 52 cards' do
    expect(@deck.cards.count).to be 52
  end

  it 'has 13 cards per suit' do
    Deck::SUITS.each do |suit|
      expect(@deck.cards.count { |card| card.suit == suit }).to be 13
    end
  end

  it 'has 4 suits per value' do
    Deck::NAME_VALUES.each do |name, value|
      expect(
        @deck.cards.count do |card|
          card.name == name && card.value == value
        end
      ).to be 4
    end
  end

  describe '#draw!' do
    it 'removes a card' do
      @deck.draw!
      expect(@deck.cards.count).to be 51
    end

    it 'removes the top card' do
      top_card   = @deck.cards.first
      drawn_card = @deck.draw!
      expect(drawn_card).to be top_card
      expect(@deck.cards).to_not include drawn_card
    end
  end
end
