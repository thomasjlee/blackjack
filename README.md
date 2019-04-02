# Blackjack

## Setup

This project was built with Ruby 2.6.1 with RSpec 3.8.0.

Download the repo and run `bundle install`.

To run the game simulation, run `ruby game.rb`.
This will simulate a single round of simplified Blackjack
where you play against the dealer (the computer).

## Specs

To run the specs, run `bundle exec rspec`.

## Assumptions

This is a simplified version of Blackjack.

The following assumptions were made:

 * A Game includes a single Player (the user) and one Dealer (the computer)
 * A Game involves only one Deck (some casino blackjack games utilize a "shoe" of 6 decks)
 * The Game currently simulates only a single round
 * There is no betting
 * There is no "splitting", "insurance", or "doubling down"

## Solution

The following illustrates the ways in which this solution satisfies the requirements listed in the original instructions:

 * As a Player I can get a hand with two cards in it

```ruby
player = Player.new
deck   = Deck.new
2.times { player.deal(deck.draw!) }
```

 * As a Dealer I can get a hand with two cards in it

```ruby
dealer = Dealer.new
deck   = Deck.new
2.times { dealer.deal(deck.draw!) }
```

 * As a Player I can see what card the dealer is showing

```ruby
game = Game.new
game.deal
game.render.table(show_dealers_hand: false)
```

 * As a Player I can bust (lose immediately) when I am getting cards

```ruby
player = Player.new
player.deal(Card.new(:hearts, :ten, 10))
player.deal(Card.new(:hearts, :ten, 10))
player.hit(Card.new(:hearts, :two, 2))
player.bust?
=> true
```

 * As a Player I can blackjack (win immediately) when I am dealt cards (this is a simplification)

```ruby
player = Player.new
player.deal(Card.new(:hearts, :ten, 10))
player.deal(Card.new(:hearts, :ace, [1, 11]))
player.blackjack?
=> true
```

 * As a Dealer I can draw cards after the player until I win or lose
   * This logic is implemented in `Game#dealer_sequence`

## Original Instructions

### Simplified Blackjack

`blackjack.rb` contains initial work on a Blackjack simulation.

Your implementation should satisfy the following use cases and Blackjack rules:

 * As a Player I can get a hand with two cards in it
 * As a Dealer I can get a hand with two cards in it
 * As a Player I can see what card the dealer is showing
 * As a Player I can bust (lose immediately) when I am getting cards
 * As a Player I can blackjack (win immediately) when I am dealt cards (this is a simplification)
 * As a Dealer I can draw cards after the player until I win or lose

**Rules:**

 * Bust - Occurs when all possible hand values are greater than 21 points
 * Blackjack - Occurs when a player or dealer is dealt an ace and a 10-point card
 * Dealer - Stays on 17 or above

Please use your discretion in fixing/adding tests. You are free to use/convert to any testing framework you want.

**Optional:**

 * Simulate a random round of the game (you don't have to write educated player decision logic - it could be just guesses)

 For more information on blackjack, please refer to its [wiki page](http://en.wikipedia.org/wiki/Blackjack).
