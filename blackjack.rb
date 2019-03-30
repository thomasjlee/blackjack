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
    ace:   [11, 1]
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

  def possible_hands
    aces, non_aces = @cards.partition { |card| card.name == :ace }
    hand_without_aces = non_aces.sum(&:value)

    if aces.count
      hands_with_aces(aces.count, hand_without_aces)
    else
      [hand_without_aces]
    end
  end

  def hands_with_aces(num_aces, hand_without_aces)
    hands = []
    (0..num_aces).each do |i|
      hands.unshift(hand_without_aces + num_aces + (i * 10))
    end
    hands
  end
end
