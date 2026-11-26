class Poker
  CARD_VALUE = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11 }
  attr_reader :best_hand

  def initialize(hands)
    scores = hands.map { |hand| tally hand }
    max_score = scores.max
    @best_hand = hands.each_with_index.select { |hand, i| scores[i] == max_score }.map(&:first)
  end

  def tally(cards)
    @values = cards.map { |card| CARD_VALUE[card[0..-2]] || card[0..-2].to_i }.sort
    @suits = cards.map { |card| card[-1] }

    score = @values.reverse.inject(1) { |sum, value| sum*10 + value }
    score += find_sets_of(2) * 10**6
    score += find_sets_of(3) * 10**8
    score += find_straight * 10**9
    score += find_flush * 10**10
    score += find_full * 10**11
    score += find_sets_of(4) * 10**13
    score += find_straight_flush * 10**14
  end

  def find_sets_of(multiple)
    sets = @values.uniq.select { |uniq_value| @values.select { |value| value == uniq_value }.count == multiple }
    (sets[0] || 0) + (sets[1] || 0)*10
  end

  def find_straight
    values = @values[-1] == 14 && @values[0] == 2 ? [1] + @values[0..3] : @values
    (values.min..values.max).to_a == values.sort ? values.max : 0
  end

  def find_flush
    @suits.uniq.count == 1 ? @values.max : 0
  end

  def find_full
    set_of_3 = find_sets_of 3
    pair = find_sets_of 2
    set_of_3 != 0 && pair != 0 ? set_of_3 * 10 + pair : 0
  end

  def find_straight_flush
    find_flush != 0 ? find_straight : 0
  end
end
