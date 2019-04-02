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
