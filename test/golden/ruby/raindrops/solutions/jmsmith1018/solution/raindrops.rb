module Raindrops
  SOUNDS = {
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }.freeze

  def self.convert(num)
    result = ""
    result += SOUNDS[3] if (num % 3).zero?
    result += SOUNDS[5] if (num % 5).zero?
    result += SOUNDS[7] if (num % 7).zero?
    result.empty? ? num.to_s : result
  end
end
