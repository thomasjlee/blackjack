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
    deal
    render_table

    result =
      blackjack_sequence ||
      player_sequence ||
      dealer_sequence ||
      final_sequence

    render_table(show_dealers_hand: true)
    render_round_ended(result)
  end

  def blackjack_sequence
    return unless player.blackjack?
    if dealer.blackjack?
      :blackjacks
    else
      :blackjack
    end
  end

  def player_sequence
    action = ''
    until action == 'stay'
      action = hit_or_stay
      player.hit(deck.draw!) if action == 'hit'
      render_table
      return :bust if player.bust?
    end
  end

  def dealer_sequence
    until dealer.must_stay?
      dealer.hit(deck.draw!)
      return :dealer_bust if dealer.bust?
    end
  end

  def final_sequence
    if dealer.final_hand > player.final_hand
      :lose
    elsif dealer.final_hand < player.final_hand
      :win
    else
      :push
    end
  end

  def deal
    2.times do
      player.deal(deck.draw!)
      dealer.deal(deck.draw!)
    end
  end

  def hit_or_stay
    print 'Hit (h) / Stay (s): '
    input = gets.chomp.strip.downcase
    if valid_hit_or_stay?(input)
      normalize_hit_or_stay(input)
    else
      puts 'You may hit or stay. Try again.'
      hit_or_stay
    end
  end

  def valid_hit_or_stay?(input)
    %w(hit h stay stand s).include?(input)
  end

  def normalize_hit_or_stay(input)
    case input
    when /^h/
      'hit'
    when /^s/
      'stay'
    end
  end

  def render_table(show_dealers_hand: false)
    puts "DEALER'S CARDS"
    if show_dealers_hand
      pp dealer.cards
    else
      pp dealer.cards[0]
      puts '[ x ]'
    end

    puts "\nYOUR CARDS"
    pp player.cards
  end

  def render_round_ended(result)
    case result
    when :blackjacks
      puts ">> BLACKJACKS! PUSH!\n\n"
    when :blackjack
      puts ">> BLACKJACK! YOU WIN!\n\n"
    when :bust
      puts ">> BUST! YOU LOSE!\n\n"
    when :dealer_bust
      puts ">> DEALER BUSTED! YOU WIN!\n\n"
    when :win
      puts ">> YOU WIN!\n\n"
    when :lose
      puts ">> YOU LOSE!\n\n"
    when :push
      puts ">> PUSH!\n\n"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play_round
end
