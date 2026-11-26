class Raindrops
  FACTOR_SOUNDS = {
    3 => "Pling",
    5 => "Plang",
    7 => "Plong",
  }

  def self.convert(num : Int32) : String
    sounds = FACTOR_SOUNDS
      .select{ |factor, _| num.divisible_by?(factor) }
      .map{ |_, sound| sound }

    sounds.empty? ? num.to_s : sounds.join
  end
end
