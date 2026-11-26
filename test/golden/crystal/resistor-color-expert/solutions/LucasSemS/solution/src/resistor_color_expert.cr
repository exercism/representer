module ResistorColorExpert
  private COLOR_VALUES = {
    "black"  => 0,
    "brown"  => 1,
    "red"    => 2,
    "orange" => 3,
    "yellow" => 4,
    "green"  => 5,
    "blue"   => 6,
    "violet" => 7,
    "grey"   => 8,
    "white"  => 9
  }

  TOLERANCE_VALUES = {
    "grey"   => 0.05,
    "violet" => 0.1,
    "blue"   => 0.25,
    "green"  => 0.5,
    "brown"  => 1,
    "red"    => 2,
    "gold"   => 5,
    "silver" => 10
  }

  UNITS = [
    { threshold: 1_000_000_000.0, suffix: "gigaohms" },
    { threshold: 1_000_000.0,     suffix: "megaohms" },
    { threshold: 1_000.0,         suffix: "kiloohms" }
  ]

  def self.resistor_label(bands : Array(String)) : String
    # Checa quantidade de bandas
    unless [1,4,5].includes?(bands.size)
      raise "Precisamos de 1, 4 ou 5 cores"
    end

    # Caso de 1 banda
    return "#{COLOR_VALUES[bands[0]]} ohms" if bands.size == 1

    # Determinar dígitos e multiplicador
    digits_count = bands.size == 4 ? 2 : 3
    digits = bands[0...digits_count].map { |c| COLOR_VALUES[c] }.join.to_i64
    multiplier = COLOR_VALUES[bands[digits_count]]

    # Calcula valor total como Float para preservar decimais
    total_value = digits.to_f * (10.0 ** multiplier)

    # Escolher unidade
    unit = "ohms"
    UNITS.each do |u|
      if total_value >= u[:threshold]
        total_value /= u[:threshold]
        unit = u[:suffix]
        break
      end
    end

    # Remover zeros desnecessários após decimal
    value_str = total_value % 1.0 == 0.0 ? total_value.to_i.to_s : total_value.round(2).to_s

    # Tolerância
    tolerance_color = bands[-1]
    tolerance = TOLERANCE_VALUES[tolerance_color]

    "#{value_str} #{unit} ±#{tolerance}%"
  end
end
