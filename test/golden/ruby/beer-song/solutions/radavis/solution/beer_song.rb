module BeerSong
  def self.recite(bottles, verses)
    result = []
    verses.times do
      result << verse(bottles)
      bottles -= 1
    end
    result.join("\n\n") + "\n"
  end

  def self.verse(i)
    line1 = "#{bottles_to_s(i).capitalize} of beer on the wall, #{bottles_to_s(i)} of beer."
    line2 = "Take #{i > 1 ? "one" : "it" } down and pass it around, #{bottles_to_s(i - 1)} of beer on the wall."
    if i == 0
      line2 = "Go to the store and buy some more, 99 bottles of beer on the wall."
    end
    [line1, line2].join("\n")
  end

  def self.bottles_to_s(i)
    return "#{i} bottles" if i > 1
    return "1 bottle" if i == 1
    "no more bottles"
  end
end
