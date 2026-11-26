module Blackjack
  def self.parse_card(card)
    case card
      when "ace" then 11
      when "two" then 2
      when "three" then 3
      when "four" then 4
      when "five" then 5
      when "six" then 6
      when "seven" then 7
      when "eight" then 8
      when "nine" then 9
      when "ten", "jack", "queen", "king" then 10
      else 0
    end
  end

  def self.card_range(card1, card2)
    points = self.parse_card(card1) + self.parse_card(card2)

    case points
    when 4..11 then "low"
    when 12..16 then "mid"
    when 17..20 then "high"
    when 21 then "blackjack"
    else "doubleace"
    end
  end

  def self.first_turn(card1, card2, dealer_card)
    case self.card_range(card1, card2)
    when "blackjack"
      case dealer_card
      when "ace", "ten", "jack", "queen", "king" then "S"
      else "W"
      end
    when "doubleace" then "P"
    when "high" then "S"
    when "mid"
      return "S" unless self.parse_card(dealer_card) >= 7
      "H"
    when "low" then "H"
    end
  end
end
