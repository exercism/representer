"""Functions to prevent a nuclear meltdown."""


def is_criticality_balanced(temperature, neutrons_emitted):
    product = temperature * neutrons_emitted
    if (temperature < 800) and (neutrons_emitted > 500) and (product < 500000):
        return True
    else:
        return False


def reactor_efficiency(voltage, current, theoretical_max_power):
    generated_power = voltage * current
    percentage = (generated_power / theoretical_max_power) * 100
    if percentage >= 80:
        efficiency = "green"
    elif percentage >= 60 and percentage < 80:
        efficiency = "orange"
    elif percentage >= 30 and percentage < 60:
        efficiency = "red"
    else: 
        efficiency = "black"
    print(efficiency)
    return efficiency


def fail_safe(temperature, neutrons_produced_per_second, threshold):
    critical = temperature * neutrons_produced_per_second
    if critical < (threshold * .9):
        message = "LOW"
    elif critical >= (threshold * .9) and critical <= (threshold * 1.10):
        message = "NORMAL"
    else:
        message = "DANGER"
    print(message)
    return message
