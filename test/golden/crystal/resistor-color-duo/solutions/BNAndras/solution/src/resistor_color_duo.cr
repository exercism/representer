module ResistorColorDuo

    COLOR_CODES = %w[black brown red orange yellow green blue violet grey white]

  def self.value(values : Array(String)) : Number
    color1, color2 = values
    COLOR_CODES.index!(color1) * 10 + COLOR_CODES.index!(color2)
  end
end
