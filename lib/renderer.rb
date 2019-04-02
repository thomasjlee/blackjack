class Renderer
  attr_accessor :context

  SUIT_CHARS = {
    spades:   '♠',
    hearts:   '♥',
    diamonds: '♦',
    clubs:    '♣'
  }.freeze

  END_OF_ROUND_MESSAGES = {
    blackjacks:  '>> BLACKJACKS! PUSH!',
    blackjack:   '>> BLACKJACK! YOU WIN!',
    bust:        '>> BUST! YOU LOSE!',
    dealer_bust: '>> DEALER BUSTED! YOU WIN!',
    win:         '>> YOU WIN!',
    lose:        '>> YOU LOSE!',
    push:        '>> PUSH!'
  }.freeze

  CARD_NAMES = {
    two:   '2',
    three: '3',
    four:  '4',
    five:  '5',
    six:   '6',
    seven: '7',
    eight: '8',
    nine:  '9',
    ten:   '10',
    jack:  'J',
    queen: 'Q',
    king:  'K',
    ace:   'A'
  }.freeze

  def player
    context[:player]
  end

  def dealer
    context[:dealer]
  end

  def hit_or_stay
    print '>> Hit (h) / Stay (s): '
  end

  def invalid_hit_or_stay
    puts '>> You may hit or stay. Try again!'
  end

  def table(show_dealers_hand: false)
    clear_screen

    puts "\n+-- DEALER"
    puts '|'

    dealer.cards.each_with_index do |card, index|
      if index == 1 && !show_dealers_hand
        puts '| ???'
      else
        puts "| #{SUIT_CHARS[card.suit]} #{format('%2s', CARD_NAMES[card.name])}"
      end
    end

    puts '|'
    puts '+---<blackjack>---+'
    puts '|'

    player.cards.each do |card|
      puts "| #{SUIT_CHARS[card.suit]} #{format('%2s', CARD_NAMES[card.name])}"
    end

    puts '|'
    puts "+-- YOU\n\n"
  end

  def final_hands
    puts ">> DEALER: #{dealer.final_hand}"
    puts ">> YOU:    #{player.final_hand}"
  end

  def end_of_round(result)
    puts END_OF_ROUND_MESSAGES[result]
  end

  def clear_screen
    # https://stackoverflow.com/a/19058589
    puts "\e[H\e[2J"
  end
end
