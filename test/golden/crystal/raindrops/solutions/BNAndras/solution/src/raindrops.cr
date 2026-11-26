class Raindrops
  SOUNDS = {3 => "Pling", 5 => "Plang", 7 => "Plong" }

  def self.convert(num : Int32) : String
    sounds = SOUNDS.select { |factor| (num % factor).zero?}.values
    sounds.empty? ? num.to_s : sounds.join
  end
end
