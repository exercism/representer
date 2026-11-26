module SpellboundSteel
  def self.find_card?(cards, card)
    cards.index card
  end

  def self.capitalize_names(characters)
    characters.map &.split(" ").map(&.capitalize).join(" ")
  end

  def self.calculate_power_level(cards)
    powers = [] of Int32
    capitalize_names(cards).each do |card|
      case card
      when "Warrior" then powers << 10
      when "Mage" then powers << 20
      when "Rogue" then powers << 30
      when "Fireball" then powers << 15
      when "Ice Storm" then powers << 25
      when "Lightning Bolt" then powers << 35
      end
    end
    powers.sum
  end

  def self.decode_characters(character)
    character.chars.map_with_index { |char, i| i % 2 != 0 ? char : nil }.join
  end
end
