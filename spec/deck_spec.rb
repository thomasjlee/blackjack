require 'spec_helper'
require_relative '../blackjack'

RSpec.describe Deck do
  before do
    @deck = Deck.new
  end

  it 'has 52 cards' do
    expect(@deck.cards.count).to be 52
  end

  describe '#deal_card' do
    it 'should remove the dealt card from playable cards' do
      card = @deck.deal_card
      expect(@deck.cards).to_not include card
    end
  end
end
