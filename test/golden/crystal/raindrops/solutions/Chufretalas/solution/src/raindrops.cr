class Raindrops
  def self.convert(num : Int32) : String
    result = ""

    if num.divisible_by?(3)
      result += "Pling"
    end

    if num.divisible_by?(5)
      result += "Plang"
    end

    if num.divisible_by?(7)
      result += "Plong"
    end

    result.blank? ? num.to_s : result
  end
end
