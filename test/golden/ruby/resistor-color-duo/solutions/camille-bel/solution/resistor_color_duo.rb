class ResistorColorDuo

  CODES = %w[black brown red orange yellow green blue violet grey white]
  #            0     1     2    3     4      5     6    7     8     9
  def self.value(colors)
    a = CODES.index(colors.first)
    b = CODES.index(colors[1])
    "#{a}#{b}".to_i
  end

end
