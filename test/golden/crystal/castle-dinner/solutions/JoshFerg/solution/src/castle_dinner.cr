class CastleDinner
  def self.check_food?(food)
    case food
    when "Mushroom pasties"
      food
    else
      nil
    end
  end

  def self.check_drink?(drink)
    if drink.downcase.includes?("i")
      drink
    else
      nil
    end
  end

  def self.replace_drink(drink)
    case check_drink?(drink)
    when nil
      "Apple juice"
    else
      drink
    end
  end
end
