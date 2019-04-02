require 'spec_helper'
require_relative '../game'

RSpec.describe Game do
  before do
    @game = Game.new(renderer: double.as_null_object)
  end

  describe '#deal' do
    it 'deals two cards to the player' do
      @game.deal
      expect(@game.player.cards.count).to be 2
    end

    it 'deals two cards to the dealer' do
      @game.deal
      expect(@game.dealer.cards.count).to be 2
    end

    it 'removes four cards from the deck' do
      @game.deal
      expect(@game.deck.cards.count).to be 48
    end
  end

  describe '#valid_hit_or_stay?' do
    it "accepts 'hit'" do
      expect(@game.valid_hit_or_stay?('hit')).to be true
    end

    it "accepts 'h'" do
      expect(@game.valid_hit_or_stay?('h')).to be true
    end

    it "accepts 'stay'" do
      expect(@game.valid_hit_or_stay?('stay')).to be true
    end

    it "accepts 'stand'" do
      expect(@game.valid_hit_or_stay?('stand')).to be true
    end

    it "accepts 's'" do
      expect(@game.valid_hit_or_stay?('s')).to be true
    end

    it 'accepts nothing else' do
      expect(@game.valid_hit_or_stay?('foo')).to be false
    end
  end

  describe '#normalize_hit_or_stay' do
    it "normalizes 'hit' to 'hit'" do
      expect(@game.normalize_hit_or_stay('hit')).to eq 'hit'
    end

    it "normalizes 'h' to 'hit'" do
      expect(@game.normalize_hit_or_stay('h')).to eq 'hit'
    end

    it "normalizes 'stay' to 'stay'" do
      expect(@game.normalize_hit_or_stay('stay')).to eq 'stay'
    end

    it "normalizes 'stand' to 'stay'" do
      expect(@game.normalize_hit_or_stay('stand')).to eq 'stay'
    end

    it "normalizes 's' to 'stay'" do
      expect(@game.normalize_hit_or_stay('s')).to eq 'stay'
    end
  end

  describe '#hit_or_stay' do
    it "should 'hit' when user wants to hit" do
      valid_hits = %w(hit h HIT HiT H)

      valid_hits.each do |hit|
        allow(@game).to receive(:gets).and_return(hit)
        expect(@game.hit_or_stay).to eq 'hit'
      end
    end

    it "should 'stay' when user wants to stay" do
      valid_stays = %w(stay stand s sTaY sTaNd S)

      valid_stays.each do |stay|
        allow(@game).to receive(:gets).and_return(stay)
        expect(@game.hit_or_stay).to eq 'stay'
      end
    end
  end

  describe '#blackjack_sequence' do
    it 'returns :blackjack if player wins with a blackjack' do
      allow(@game.player).to receive(:blackjack?).and_return(true)
      allow(@game.dealer).to receive(:blackjack?).and_return(false)
      expect(@game.blackjack_sequence).to be :blackjack
    end

    it 'returns :blackjacks if both player and dealer have blackjack' do
      allow(@game.player).to receive(:blackjack?).and_return(true)
      allow(@game.dealer).to receive(:blackjack?).and_return(true)
      expect(@game.blackjack_sequence).to be :blackjacks
    end

    it 'returns nil if neither players has blackjack' do
      allow(@game.player).to receive(:blackjack?).and_return(false)
      allow(@game.dealer).to receive(:blackjack?).and_return(false)
      expect(@game.blackjack_sequence).to be nil
    end
  end

  describe '#player_sequence' do
    it 'returns :bust if player hits then busts' do
      allow(@game).to receive(:hit_or_stay).and_return('hit')
      allow(@game.player).to receive(:bust?).and_return(true)
      expect(@game.player_sequence).to be :bust
    end

    it 'returns nil if player stays' do
      allow(@game).to receive(:hit_or_stay).and_return('stay')
      expect(@game.player_sequence).to be nil
    end
  end

  describe '#dealer_sequence' do
    it 'returns :dealer_bust if dealer hits then busts' do
      allow(@game.dealer).to receive(:must_stay?).and_return(false)
      allow(@game.dealer).to receive(:bust?).and_return(true)
      expect(@game.dealer_sequence).to be :dealer_bust
    end

    it 'returns nil if dealer must stay' do
      allow(@game.dealer).to receive(:must_stay?).and_return(true)
      expect(@game.dealer_sequence).to be nil
    end
  end

  describe '#final_sequence' do
    it 'returns :lose if player loses' do
      allow(@game.player).to receive(:final_hand).and_return(20)
      allow(@game.dealer).to receive(:final_hand).and_return(21)
      expect(@game.final_sequence).to be :lose
    end

    it 'returns :win if player wins' do
      allow(@game.player).to receive(:final_hand).and_return(21)
      allow(@game.dealer).to receive(:final_hand).and_return(20)
      expect(@game.final_sequence).to be :win
    end

    it 'returns :push if player and dealer tie' do
      allow(@game.player).to receive(:final_hand).and_return(21)
      allow(@game.dealer).to receive(:final_hand).and_return(21)
      expect(@game.final_sequence).to be :push
    end
  end
end
