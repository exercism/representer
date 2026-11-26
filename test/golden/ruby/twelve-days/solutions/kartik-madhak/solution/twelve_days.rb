class TwelveDays
  @song_words = [
    {
      day_count: "first",
      day_number: "a",
      thing: "Partridge in a Pear Tree",
    },
    {
      day_count: "second",
      day_number: "two",
      thing: "Turtle Doves",
    },
    {
      day_count: "third",
      day_number: "three",
      thing: "French Hens",
    },
    {
      day_count: "fourth",
      day_number: "four",
      thing: "Calling Birds",
    },
    {
      day_count: "fifth",
      day_number: "five",
      thing: "Gold Rings",
    },
    {
      day_count: "sixth",
      day_number: "six",
      thing: "Geese-a-Laying",
    },
    {
      day_count: "seventh",
      day_number: "seven",
      thing: "Swans-a-Swimming",
    },
    {
      day_count: "eighth",
      day_number: "eight",
      thing: "Maids-a-Milking",
    },
    {
      day_count: "ninth",
      day_number: "nine",
      thing: "Ladies Dancing",
    },
    {
      day_count: "tenth",
      day_number: "ten",
      thing: "Lords-a-Leaping",
    },
    {
      day_count: "eleventh",
      day_number: "eleven",
      thing: "Pipers Piping",
    },
    {
      day_count: "twelfth",
      day_number: "twelve",
      thing: "Drummers Drumming",
    },
  ];

  def self.song
    res = ""
    @song_words.each_with_index do |line, i|
      if i != @song_words.count() and i != 0
        res += "\n"
      end
      res += "On the #{line[:day_count]} day of Christmas my true love gave to me: "
      i.downto(0) do |j|
        line2 = @song_words[j]
        if j == 0 
          if i != 0
            res += "and #{line2[:day_number]} #{line2[:thing]}."
          else
            res += "#{line2[:day_number]} #{line2[:thing]}."
          end
        else
          res += "#{line2[:day_number]} #{line2[:thing]}, "
        end
      end
      res += "\n"
    end
    return res
  end
end

puts TwelveDays.song