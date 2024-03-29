require_relative 'card'

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
