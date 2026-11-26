module ResistorColor
  private COLORS = {
    "black"  => 0,
    "brown"  => 1,
    "red"    => 2,
    "orange" => 3,
    "yellow" => 4,
    "green"  => 5,
    "blue"   => 6,
    "violet" => 7,
    "grey"   => 8,
    "white"  => 9,
  }

  def self.color_code(color : String) : Int32 | Nil
    COLORS[color]?
  end

  def self.colors : Array
    COLORS.keys
  end
end
