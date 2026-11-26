class Reactor
  def self.criticality_balanced?(temperature, neutrons_emitted)
    (temperature < 800) &&
    (neutrons_emitted > 500) &&
    ((temperature * neutrons_emitted) < 500000)
  end

  def self.reactor_efficiency(voltage, current, theoretical_max_power)
    generated_power = voltage * current
    efficiency = (generated_power / theoretical_max_power)*100
    if efficiency < 30
      "black"
    elsif efficiency < 60
      "red"
    elsif efficiency < 80
      "orange"
    else
      "green"
    end
  end

  def self.fail_safe(temperature, neutrons_produced_per_second, threshold)
    v = temperature * neutrons_produced_per_second
    if v < (threshold * 0.9)
      "LOW"
    elsif v < (threshold * 1.1)
      "NORMAL"
    else
      "DANGER"
    end
  end
end
