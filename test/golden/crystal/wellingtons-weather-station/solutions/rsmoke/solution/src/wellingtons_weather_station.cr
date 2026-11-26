class Temperature
  def to_kelvin(celsius)
    celsius + 273.15
  end

  def round(celsius)
    celsius.round(1)
  end

  def to_fahrenheit(celsius)
    ((celsius * 1.8) + 32).to_i
  end

  def number_missing_sensors(number_of_sensors)
    required_sensors_needed = 0
    spare_sensors = number_of_sensors % 4
    if spare_sensors > 0
      required_sensors_needed = 4 - spare_sensors
    end
  required_sensors_needed
  end
end
