class CastleDinner
  def self.check_food?(food)
    food if food == "Mushroom pasties"
  end

  def self.check_drink?(drink)
    drink if drink.matches?(/[iI]/)
  end

  def self.replace_drink(drink)
    check_drink?(drink) || "Apple juice"
  end
end
