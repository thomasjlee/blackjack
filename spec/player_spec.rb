require 'spec_helper'
require_relative '../blackjack'

RSpec.describe Player do
  let(:ace)   { Card.new(:hearts, :ace, [11, 1]) }
  let(:two)   { Card.new(:hearts, :two, 2) }
  let(:three) { Card.new(:hearts, :three, 3) }
  let(:four)  { Card.new(:hearts, :four, 4) }
  let(:five)  { Card.new(:hearts, :five, 5) }
  let(:six)   { Card.new(:hearts, :six, 6) }
  let(:seven) { Card.new(:hearts, :seven, 7) }
  let(:eight) { Card.new(:hearts, :eight, 8) }
  let(:nine)  { Card.new(:hearts, :nine, 9) }
  let(:ten)   { Card.new(:hearts, :ten, 10) }
  let(:jack)  { Card.new(:hearts, :jack, 10) }
  let(:queen) { Card.new(:hearts, :queen, 10) }
  let(:king)  { Card.new(:hearts, :king, 10) }

  before :each do
    @player = Player.new
  end

  describe '#deal (alias: #hit)' do
    it 'deals a card' do
      @player.deal(double)
      expect(@player.cards.count).to be 1
    end

    it 'deals multiple cards' do
      @player.deal(double)
      @player.deal(double)
      expect(@player.cards.count).to be 2
    end
  end

  describe '#possible_hands' do
    context 'without aces' do
      it 'gives the value of one card' do
        non_aces = [
          two,
          three,
          four,
          five,
          six,
          seven,
          eight,
          nine,
          ten,
          jack,
          queen,
          king
        ]
        non_aces.each do |non_ace|
          @player.cards.clear
          @player.deal(non_ace)
          expect(@player.possible_hands).to contain_exactly non_ace.value
        end
      end

      it 'adds the values of many cards' do
        non_aces = [
          two,
          three,
          four,
          five,
          six,
          seven,
          eight,
          nine,
          ten,
          jack,
          queen,
          king
        ]
        non_aces.each { |non_ace| @player.deal(non_ace) }
        expect(@player.possible_hands).to contain_exactly non_aces.sum(&:value)
      end
    end

    context 'with aces' do
      it 'gives the values of an ace' do
        @player.deal(ace)
        expect(@player.possible_hands).to contain_exactly 1, 11
      end

      it 'gives the possible hands of two aces' do
        2.times { @player.deal(ace) }
        expect(@player.possible_hands).to contain_exactly 2, 12, 22
      end

      it 'gives the possible hands of three aces' do
        3.times { @player.deal(ace) }
        expect(@player.possible_hands).to contain_exactly 3, 13, 23, 33
      end

      it 'gives the possible hands of four aces' do
        4.times { @player.deal(ace) }
        expect(@player.possible_hands).to contain_exactly 4, 14, 24, 34, 44
      end

      it 'gives possible hands of an ace and non-aces of arbitrary value' do
        (2..25).each do |val|
          @player.cards.clear
          @player.deal(ace)
          @player.deal(double(val.to_s, name: :non_ace, value: val))

          expect(
            @player.possible_hands
          ).to contain_exactly((1 + val), (11 + val))
        end
      end

      it 'gives possible hands of two aces and non-aces of arbitrary value' do
        (2..25).each do |val|
          @player.cards.clear
          @player.deal(ace)
          @player.deal(ace)
          @player.hit(double(val.to_s, name: :non_ace, value: val))

          expect(
            @player.possible_hands
          ).to contain_exactly((2 + val), (12 + val), (22 + val))
        end
      end

      it 'gives possible hands of three aces and non-aces of arbitrary value' do
        (2..25).each do |val|
          @player.cards.clear
          @player.deal(ace)
          @player.deal(ace)
          @player.hit(ace)
          @player.hit(double(val.to_s, name: :non_ace, value: val))

          expect(
            @player.possible_hands
          ).to contain_exactly((3 + val), (13 + val), (23 + val), (33 + val))
        end
      end

      it 'gives possible hands of four aces and non-aces of arbitrary value' do
        (2..25).each do |val|
          @player.cards.clear
          @player.deal(ace)
          @player.deal(ace)
          @player.hit(ace)
          @player.hit(ace)
          @player.hit(double(val.to_s, name: :non_ace, value: val))

          expect(
            @player.possible_hands
          ).to contain_exactly((4 + val), (14 + val),
                               (24 + val), (34 + val),
                               (44 + val))
        end
      end
    end
  end

  describe '#blackjack? (alias: #twenty_one?)' do
    it 'identifies all blackjacks' do
      blackjacks = [
        [ace, ten],
        [ace, jack],
        [ace, queen],
        [ace, king]
      ]
      blackjacks.each do |ace, non_ace|
        @player.cards.clear
        @player.deal(ace)
        @player.deal(non_ace)
        expect(@player).to be_blackjack
      end
    end

    it 'identifies a hand with an ace that is not blackjack' do
      two_through_nine = [
        two,
        three,
        four,
        five,
        six,
        seven,
        eight,
        nine
      ]
      two_through_nine.each do |other_card|
        @player.cards.clear
        @player.deal(ace)
        @player.deal(other_card)
        expect(@player).to_not be_blackjack
      end
    end
  end

  describe '#bust?' do
    it 'a player with at least one hand under 21 is not bust' do
      (22..30).each do |val|
        allow(@player).to receive(:possible_hands).and_return([val, 21])
        expect(@player).to_not be_bust
      end
    end

    it 'a player whose hands are all over 21 is bust' do
      (22..30).each do |val|
        allow(@player).to receive(:possible_hands).and_return([val])
        expect(@player).to be_bust
      end
    end
  end
end
