require_relative 'player'

class Dealer < Player
  def must_stay?
    if ace?
      possible_hands.any? { |hand| hand.between?(17, 21) }
    else
      hand = possible_hands.first
      hand >= 17
    end
  end
end
