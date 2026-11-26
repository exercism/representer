=begin
Write your code for the 'Twelve Days' exercise in this file. Make the tests in
`twelve_days_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/twelve-days` directory.
=end

# frozen_string_literal: true

class TwelveDays
  CARDINAL_NUMBERS = %w[first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth]

  GIFTS = [
    'a Partridge in a Pear Tree.',
    'two Turtle Doves',
    'three French Hens',
    'four Calling Birds',
    'five Gold Rings',
    'six Geese-a-Laying',
    'seven Swans-a-Swimming',
    'eight Maids-a-Milking',
    'nine Ladies Dancing',
    'ten Lords-a-Leaping',
    'eleven Pipers Piping',
    'twelve Drummers Drumming'
  ]

  def self.song
    lyric = ''
    presents = []

    (0..11).each do |num|
      base = "On the #{CARDINAL_NUMBERS[num]} day of Christmas my true love gave to me:"

      if num == 0
        presents.prepend "and #{GIFTS[num]}"
        lyric += "#{base} #{GIFTS[num]}\n"
      else
        presents.prepend "#{GIFTS[num]}"
        lyric += "\n#{base} #{presents.join(', ')}\n"
      end
    end

    lyric
  end
end
