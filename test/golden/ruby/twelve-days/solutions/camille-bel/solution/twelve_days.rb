# frozen_string_literal: true

class TwelveDays
  GIFTS = [
    'a Partridge in a Pear Tree.',
    'two Turtle Doves, and ',
    'three French Hens, ',
    'four Calling Birds, ',
    'five Gold Rings, ',
    'six Geese-a-Laying, ',
    'seven Swans-a-Swimming, ',
    'eight Maids-a-Milking, ',
    'nine Ladies Dancing, ',
    'ten Lords-a-Leaping, ',
    'eleven Pipers Piping, ',
    'twelve Drummers Drumming, '
  ].freeze

  ORDINALZ = %w[first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth].freeze

  def self.song
    day = 0
    song = ''

    (0...12).each do |i|
      gifts = ''
      y = i
      while y >= 0
        gifts += GIFTS[y]
        y -= 1
      end
      song += "On the #{ORDINALZ[i]} day of Christmas my true love gave to me: #{gifts}\n"
      song += "\n" unless i == 11
      day += 1
    end
    song
  end
end
