require 'spec_helper'
require_relative '../blackjack'

RSpec.describe Deck do
  before do
    @deck = Deck.new
  end

  it 'has 52 playable cards' do
    expect(@deck.playable_cards.count).to be 52
  end

  describe '#deal_card' do
    it 'should remove the dealt card from playable cards' do
      card = @deck.deal_card
      expect(@deck.playable_cards).to_not include(card)
    end
  end

  describe '#shuffle' do
    it 'has 52 cards after shuffling' do
      @deck.shuffle
      expect(@deck.playable_cards.count).to be 52
    end
  end
end
