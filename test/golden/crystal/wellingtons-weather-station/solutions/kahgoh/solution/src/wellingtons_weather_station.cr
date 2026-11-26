class Temperature
  def to_kelvin(celsius)
    celsius.to_f + 273.15
  end

  def round(celsius)
    celsius.round(1)
  end

  def to_fahrenheit(celsius)
    ((celsius.to_f * 9/5) + 32).to_i
  end

  def number_missing_sensors(number_of_sensors)
    rem = number_of_sensors % 4
    if rem > 0 
      return 4 - rem
    end
    return 0
  end
end
