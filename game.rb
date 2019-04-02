require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/dealer'
require_relative 'lib/renderer'

class Game
  attr_reader :deck, :dealer, :player, :render

  def initialize(renderer: Renderer.new)
    @deck   = Deck.new
    @dealer = Dealer.new
    @player = Player.new
    @render = renderer
    @render.context = { player: @player, dealer: @dealer }
  end

  def play_round
    deal
    render.table

    result =
      blackjack_sequence ||
      player_sequence ||
      dealer_sequence ||
      final_sequence

    render.table(show_dealers_hand: true)
    render.final_hands
    render.end_of_round(result)
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
      render.table
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
    render.hit_or_stay
    input = gets.chomp.strip.downcase
    if valid_hit_or_stay?(input)
      normalize_hit_or_stay(input)
    else
      render.invalid_hit_or_stay
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
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play_round
end
