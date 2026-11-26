module ResistorColor
  def self.color_code(color : String) : Int32 | Nil
    colors.index color
  end

  def self.colors : Array
    %w(black brown red orange yellow green blue violet grey white)
  end
end
