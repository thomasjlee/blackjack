require 'spec_helper'
require_relative '../blackjack'

RSpec.describe Dealer do
  before :each do
    @dealer = Dealer.new
  end

  describe '#must_stay?' do
    context 'when dealer has an ace' do
      it 'dealer must stay with a hand of 17 through 21' do
        allow(@dealer).to receive(:ace?).and_return(true)
        (6..10).each do |non_ace_value|
          allow(@dealer).to receive(:possible_hands).and_return([non_ace_value + 1, non_ace_value + 11])
          expect(@dealer.must_stay?).to be true
        end
      end

      it 'dealer must hit with a hand less than 17' do
        allow(@dealer).to receive(:ace?).and_return(true)
        (2..5).each do |non_ace_value|
          allow(@dealer).to receive(:possible_hands).and_return([non_ace_value + 1, non_ace_value + 11])
          expect(@dealer.must_stay?).to be false
        end
      end
    end

    context 'when dealer does not have an ace' do
      it 'dealer must stay with hand of 17 through 21' do
        (17..21).each do |hand|
          allow(@dealer).to receive(:possible_hands).and_return([hand])
          expect(@dealer.must_stay?).to be true
        end
      end

      it 'dealer must stay if they busted' do
        (22..27).each do |hand|
          allow(@dealer).to receive(:possible_hands).and_return([hand])
          expect(@dealer.must_stay?).to be true
        end
      end

      it 'dealer must hit with a hand less than 17' do
        (1..16).each do |hand|
          allow(@dealer).to receive(:possible_hands).and_return([hand])
          expect(@dealer.must_stay?).to be false
        end
      end
    end
  end
end
