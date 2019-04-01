class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit  = suit
    @name  = name
    @value = value
  end
end

class Deck
  attr_reader :cards

  SUITS = [
    :hearts,
    :diamonds,
    :spades,
    :clubs
  ].freeze

  NAME_VALUES = {
    two:   2,
    three: 3,
    four:  4,
    five:  5,
    six:   6,
    seven: 7,
    eight: 8,
    nine:  9,
    ten:   10,
    jack:  10,
    queen: 10,
    king:  10,
    ace:   [1, 11]
  }.freeze

  def initialize
    @cards = generate_cards.shuffle!
  end

  def draw!
    @cards.shift
  end

  private

  def generate_cards
    cards = []

    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        cards << Card.new(suite, name, value)
      end
    end

    cards
  end
end

class Player
  attr_reader :cards

  def initialize
    @cards = []
  end

  def deal(card)
    @cards << card
  end
  alias hit deal

  def blackjack?
    possible_hands.include?(21)
  end
  alias twenty_one? blackjack?

  def bust?
    possible_hands.all? { |hand| hand > 21 }
  end

  def possible_hands
    aces, non_aces = @cards.partition { |card| card.name == :ace }
    if ace?
      hands_with_aces(aces, non_aces)
    else
      [hand_without_aces(non_aces)]
    end
  end

  # TODO: test me
  def final_hand
    if bust?
      possible_hands.min
    else
      possible_hands.select { |hand| hand <= 21 }.max
    end
  end

  private

  def hand_without_aces(non_aces)
    non_aces.sum(&:value)
  end

  def hands_with_aces(aces, non_aces)
    hands = []
    (0..aces.count).each do |i|
      hands << hand_without_aces(non_aces) + aces.count + (i * 10)
    end
    hands
  end

  def ace?
    @cards.any? { |card| card.name == :ace }
  end
end

class Dealer < Player
  # TODO: test me
  def must_stay?
    if ace?
      possible_hands.any? { |hand| hand.between?(17, 21) }
    else
      hand = possible_hands.first
      hand >= 17
    end
  end
end

require 'pp'

dealer = Dealer.new
player = Player.new
deck = Deck.new

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
