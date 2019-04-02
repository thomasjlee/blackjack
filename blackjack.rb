require 'pp'
require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/dealer'

class Game
  attr_reader :deck, :dealer, :player

  def initialize
    @deck   = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def play_round
    # deal card to player, then dealer (2 cards each)
    2.times do
      player.deal(deck.draw!)
      dealer.deal(deck.draw!)
    end

    puts "DEALER'S CARDS"
    # dealer's second dealt card is face-down
    pp dealer.cards[0]
    puts '[ x ]'

    puts "\nYOUR CARDS"
    pp player.cards

    # if player has blackjack, it's the end of the round
    # if dealer also has blackjack
    #   it's a push
    # otherwise
    #   player has won

    if player.blackjack?
      if dealer.blackjack?
        puts "PUSH!"
      else
        puts "YOU WIN!"
      end
    end

    # if player does not have blackjack, we ask: hit or stay?
    if !player.blackjack?
      hit_or_stay = ''
      until hit_or_stay == 'stay' || player.bust? || player.twenty_one?
        puts 'hit or stay?'
        hit_or_stay = gets.chomp.downcase
        if hit_or_stay == 'hit'
          player.deal(deck.draw!)

          # render the hands
          puts "DEALER'S CARDS"
          pp dealer.cards[0]
          puts '[ x ]'

          puts "\nYOUR CARDS"
          pp player.cards
        end
      end

      if player.bust?
        puts "BUST! YOU LOSE!"
        return
      end

      # then it's the dealer's sequence
      # dealer hits until bust or greater than (or equal to) 17

      until dealer.must_stay? || dealer.bust?
        puts "... dealer hits ..."
        dealer.hit(deck.draw!)
        # now, the dealer's hand is revealed
        # render the hands
        puts "DEALER'S CARDS"
        pp dealer.cards

        puts "\nYOUR CARDS"
        pp player.cards
      end

      if dealer.bust?
        puts "DEALER BUST! YOU WIN!"
      end
    end

    # if neither has busted and the player has not blackjacked
    # (this will be better captured in a loop)
    # then, finally, compare the hands to see who wins
    if !player.blackjack? && !player.bust? && !dealer.bust?
      if dealer.final_hand > player.final_hand
        puts "DEALER WINS!"
      elsif player.final_hand > dealer.final_hand
        puts "YOU WIN!"
      else
        puts "PUSH!"
      end
    end
  end
end

if $0 == __FILE__
  game = Game.new
  game.play_round
end
