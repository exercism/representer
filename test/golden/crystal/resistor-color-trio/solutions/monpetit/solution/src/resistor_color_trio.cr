module ResistorColorTrio
  COLORS = {
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

  def self.label(values : Array(String)) : String
    resistor = values[..1]
      .map { |color| COLORS[color] }
      .join
      .to_i
      .to_s + "0" * COLORS[values[2]] + " ohms"
    resistor.gsub(/0{9} ohms/, " gigaohms")
      .gsub(/0{6} ohms/, " megaohms")
      .gsub(/0{3} ohms/, " kiloohms")
  end
end
