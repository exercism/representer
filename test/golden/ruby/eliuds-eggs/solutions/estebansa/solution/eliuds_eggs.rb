class EliudsEggs
  def self.egg_count(eggs_decimal)
    eggs_decimal.to_s(2).count("1")
  end
end