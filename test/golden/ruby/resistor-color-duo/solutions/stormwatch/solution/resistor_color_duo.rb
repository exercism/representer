class ResistorColorDuo
  
  COLOR_CODE = {
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
    }

  def self.value((first_color, second_color))
    COLOR_CODE[first_color.to_sym] * 10 + COLOR_CODE[second_color.to_sym]
  end
end