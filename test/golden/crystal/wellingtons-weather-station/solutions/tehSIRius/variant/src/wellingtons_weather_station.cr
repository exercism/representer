class Temperature
  ZERO_KELVIN_TO_CELSIUS = -273.15

  def to_kelvin(celsius)
    celsius.to_f - ZERO_KELVIN_TO_CELSIUS
  end

  def round(celsius)
    celsius - (celsius.to_f % 0.1)
  end

  def to_fahrenheit(celsius)
    ((celsius * 9.0 / 5.0) + 32).to_i
  end

  def number_missing_sensors(number_of_sensors)
    remainder = number_of_sensors % 4

    if remainder != 0
      return 0
    end

    4 - remainder
  end
end
