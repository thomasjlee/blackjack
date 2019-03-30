require 'spec_helper'
require_relative '../blackjack'

RSpec.describe Player do
  before :all do
    @ace   = Card.new(:hearts, :ace, [11, 1])
    @two   = Card.new(:hearts, :two, 2)
    @three = Card.new(:hearts, :three, 3)
    @four  = Card.new(:hearts, :four, 4)
    @five  = Card.new(:hearts, :five, 5)
    @six   = Card.new(:hearts, :six, 6)
    @seven = Card.new(:hearts, :seven, 7)
    @eight = Card.new(:hearts, :eight, 8)
    @nine  = Card.new(:hearts, :nine, 9)
    @ten   = Card.new(:hearts, :ten, 10)
    @jack  = Card.new(:hearts, :jack, 10)
    @queen = Card.new(:hearts, :queen, 10)
    @king  = Card.new(:hearts, :king, 10)

    @blackjacks = [
      [@ace, @ten],
      [@ace, @jack],
      [@ace, @queen],
      [@ace, @king]
    ]
  end

  before :each do
    @player = Player.new
  end

  describe '#deal' do
    it 'deals a card' do
      @player.deal(double)
      expect(@player.cards.count).to be 1
    end

    it 'deals multiple cards' do
      @player.deal(double)
      @player.deal(double)
      @player.hit(double)
      expect(@player.cards.count).to be 3
    end

    it 'is aliased by #hit' do
      @player.hit(double)
      expect(@player.cards.count).to be 1
    end
  end

  describe '#possible_hands' do
    context 'without aces' do
      it 'adds up two cards' do
        @player.deal(@two)
        @player.deal(@king)
        expect(@player.possible_hands).to eq [12]
      end

      it 'adds up three cards' do
        @player.deal(@two)
        @player.deal(@four)
        @player.hit(@king)
        expect(@player.possible_hands).to eq [16]
      end

      it 'adds up four cards' do
        @player.deal(@two)
        @player.deal(@four)
        @player.hit(@six)
        @player.hit(@king)
        expect(@player.possible_hands).to eq [22]
      end

      it 'adds up five cards' do
        @player.deal(@two)
        @player.deal(@three)
        @player.hit(@seven)
        @player.hit(@queen)
        @player.hit(@king)
        expect(@player.possible_hands).to eq [32]
      end
    end

    context 'with one ace' do
      it 'returns possible hands with two cards' do
        @player.deal(@ace)
        @player.deal(@two)
        expect(@player.possible_hands).to eq [13, 3]
      end

      it 'returns possible hands with three cards' do
        @player.deal(@ace)
        @player.deal(@three)
        @player.hit(@five)
        expect(@player.possible_hands).to eq [19, 9]
      end

      it 'returns possible hands with four cards' do
        @player.deal(@ace)
        @player.deal(@four)
        @player.hit(@six)
        @player.hit(@eight)
        expect(@player.possible_hands).to eq [29, 19]
      end

      it 'returns possible hands with five cards' do
        @player.deal(@ace)
        @player.deal(@three)
        @player.hit(@five)
        @player.hit(@seven)
        @player.hit(@nine)
        expect(@player.possible_hands).to eq [35, 25]
      end
    end

    context 'with two aces' do
      it 'returns possible hands with two cards' do
        @player.deal(@ace)
        @player.deal(@ace)
        expect(@player.possible_hands).to eq [22, 12, 2]
      end

      it 'returns possible hands with three cards' do
        @player.deal(@ace)
        @player.deal(@ace)
        @player.hit(@three)
        expect(@player.possible_hands).to eq [25, 15, 5]
      end

      it 'returns possible hands with four cards' do
        @player.deal(@ace)
        @player.deal(@ace)
        @player.hit(@six)
        @player.hit(@eight)
        expect(@player.possible_hands).to eq [36, 26, 16]
      end

      it 'returns possible hands with five cards' do
        @player.deal(@ace)
        @player.deal(@ace)
        @player.hit(@five)
        @player.hit(@seven)
        @player.hit(@nine)
        expect(@player.possible_hands).to eq [43, 33, 23]
      end
    end
  end

  describe '#blackjack?' do
    it 'identifies all blackjacks' do
      @blackjacks.each do |ace, non_ace|
        @player.cards.clear
        @player.deal(ace)
        @player.deal(non_ace)
        expect(@player).to be_blackjack
      end
    end

    it 'identifies a non-blackjack' do
      @player.deal(@ace)
      @player.deal(@nine)
      expect(@player).to_not be_blackjack
    end
  end

  describe '#twenty_one?' do
    context 'without an ace' do
      it 'identifies a three-card twenty-one' do
        @player.deal(@ten)
        @player.deal(@six)
        @player.hit(@five)
        expect(@player).to be_twenty_one
      end

      it 'identifies a four-card twenty-one' do
        @player.deal(@ten)
        @player.deal(@six)
        @player.hit(@three)
        @player.hit(@two)
        expect(@player).to be_twenty_one
      end

      it 'identifies a five-card twenty-one' do
        @player.deal(@seven)
        @player.deal(@six)
        @player.hit(@four)
        @player.hit(@two)
        @player.hit(@two)
        expect(@player).to be_twenty_one
      end
    end

    context 'with an ace-low' do
      it 'and two tens makes twenty-one' do
        @player.deal(@ten)
        @player.deal(@ten)
        @player.hit(@ace)
        expect(@player).to be_twenty_one
      end

      it 'and ten and two other cards makes twenty-one' do
        makes_ten = [
          [@two, @eight],
          [@three, @seven],
          [@four, @six],
          [@five, @five]
        ]
        makes_ten.each do |a, b|
          @player.cards.clear
          @player.deal(@ten)
          @player.deal(a)
          @player.hit(b)
          @player.hit(@ace)
          expect(@player).to be_twenty_one
        end
      end

      it 'and ten and three other cards makes twenty-one' do
        makes_ten = [
          [@two, @three, @five],
          [@two, @four, @four],
          [@three, @three, @four]
        ]
        makes_ten.each do |a, b, c|
          @player.cards.clear
          @player.deal(@ten)
          @player.deal(a)
          @player.hit(b)
          @player.hit(c)
          @player.hit(@ace)
          expect(@player).to be_twenty_one
        end
      end
    end

    context 'with an ace-high' do
      it 'and two cards makes twenty-one' do
        makes_ten = [
          [@two, @eight],
          [@three, @seven],
          [@four, @six],
          [@five, @five]
        ]
        makes_ten.each do |a, b|
          @player.cards.clear
          @player.deal(a)
          @player.deal(b)
          @player.hit(@ace)
          expect(@player).to be_twenty_one
        end
      end

      it 'and three cards makes twenty-one' do
        makes_ten = [
          [@two, @three, @five],
          [@two, @four, @four],
          [@three, @three, @four]
        ]
        makes_ten.each do |a, b, c|
          @player.cards.clear
          @player.deal(a)
          @player.deal(b)
          @player.hit(c)
          @player.hit(@ace)
          expect(@player).to be_twenty_one
        end
      end
    end

    context 'two aces' do
      it 'and two cards makes twenty-one' do
        makes_nine = [
          [@two, @seven],
          [@three, @six],
          [@four, @five]
        ]
        makes_nine.each do |a, b|
          @player.cards.clear
          @player.deal(@ace)
          @player.deal(@ace)
          @player.hit(a)
          @player.hit(b)
          expect(@player).to be_twenty_one
        end
      end

      it 'and three cards makes twenty-one' do
        makes_nine = [
          [@two, @two, @five],
          [@two, @three, @four],
          [@three, @three, @three]
        ]
        makes_nine.each do |a, b, c|
          @player.cards.clear
          @player.deal(@ace)
          @player.deal(@ace)
          @player.hit(a)
          @player.hit(b)
          @player.hit(c)
          expect(@player).to be_twenty_one
        end
      end
    end
  end
end
