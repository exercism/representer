module Raindrops
  CONVERT = [{3, "Pling"}, {5, "Plang"}, {7, "Plong"}]

  def self.convert(input : Int)
    drops = [] of String

    CONVERT.each do |key, value|
      drops << value if input.divisible_by? key
    end

    drops.empty? ? input.to_s : drops.join
  end
end
