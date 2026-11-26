module ResistorColor
  # Write your code for the 'Resistor Color' exercise in this file.
  def self.color_code(color : String) : Int32 | Nil
    colors.index(color)
  end

  def self.colors : Array
    ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]
  end
end
