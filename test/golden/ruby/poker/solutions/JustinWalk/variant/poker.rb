class Poker
  HANDS = [
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush, 
    :straight,
    :three_of_a_kind,
    :two_pair,
    :pair,
    :high
  ]

  CARDS = [
    "A",
    "K",
    "Q",
    "J",
    "10",
    "9",
    "8",
    "7",
    "6",
    "5",
    "4",
    "3",
    "2",
    "A"
  ]
  
  def initialize(hands)
    @hands = hands
  end
  
  def best_hand
    result = []
    
    HANDS.each do |hand_type|
      result = self.send(hand_type, @hands)
      break unless result.empty?
    end
    
    result
  end

  # UTILITY
  def values(hand)
    hand.map {|card| card[0..-2]}
  end

  def suits(hand)
    hand.map {|card| card[-1]}
  end

  # HANDS
  def straight_flush(hands)
    flush_hands = []
    hands.each do |hand|
      flsh = self.flush([hand])
      flush_hands << flsh[0] unless flsh.empty?
    end
    return [] if flush_hands.empty?
    self.straight(flush_hands)
  end
  
  def four_of_a_kind(hands)
    hits = []
    CARDS.each do |card|
      hands.each do |hand|
        hits << hand if values(hand).count(card) == 4
      end
      break if hits.size != 0
    end
    high(hits)
  end

  def full_house(hands)
    hands = hands.select { |hand| values(hand).uniq.size == 2 }
    hands = self.three_of_a_kind(hands)
    self.pair(hands)
  end

  def flush(hands)
    hits = []
    hands.each do |hand|
      if suits(hand).uniq.size == 1
        hits << hand
      else
        next
      end
    end
    high(hits)
  end

  def straight(hands)
    hits = []
    CARDS.each_cons(5).each do |strt|
      hands.each do |hand|
        if strt.sort == values(hand).sort
          hits << hand
        end
      end
      break unless hits.empty?
    end
    hits
  end

  def three_of_a_kind(hands)
    hits = []
    CARDS.each do |card|
      hands.each do |hand|
        hits << hand if values(hand).count(card) == 3
      end
      break if hits.size != 0
    end
    high(hits)
  end

  def two_pair(hands)
    hands = hands.select { |hand| values(hand).uniq.count == 3}
    CARDS.each do |card|
      if hands.any? {|hand| values(hand).tally[card] == 2}
        hands = hands.select { |hand| values(hand).tally[card] != 2 }
      end
      break if hands.size == 1
    end
    high(hands)
  end

  def pair(hands)
    hits = []
    CARDS.each do |card|
      hands.each do |hand|
        hits << hand if values(hand).count(card) == 2
      end
      break if hits.size != 0
    end
    high(hits)
  end

  def high(hands)
    return hands if hands.size == 1
    CARDS.each do |card|
      if hands.any? {|hand| values(hand).include?(card) }
        hands = hands.select { |hand| values(hand).include?(card) }
      end
      break if hands.size == 1
    end
    hands
  end
  
end