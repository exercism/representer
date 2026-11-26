=begin
Write your code for the 'Twelve Days' exercise in this file. Make the tests in
`twelve_days_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/twelve-days` directory.
=end
class TwelveDays
  def self.song
    h = {
      "first": "a Partridge in a Pear Tree.\n",
      "second": "two Turtle Doves, and ",
      "third": "three French Hens, ",
      "fourth": "four Calling Birds, ",
      "fifth": "five Gold Rings, ",
      "sixth": "six Geese-a-Laying, ",
      "seventh": "seven Swans-a-Swimming, ",
      "eighth": "eight Maids-a-Milking, ",
      "ninth": "nine Ladies Dancing, ",
      "tenth": "ten Lords-a-Leaping, ",
      "eleventh": "eleven Pipers Piping, ",
      "twelfth": "twelve Drummers Drumming, ",
    }
    (1..11).map do |i|
      "On the #{h.keys[i]} day of Christmas my true love gave to me: #{h.values[0..i].reverse.join}"
    end.join("\n")
  end
end
