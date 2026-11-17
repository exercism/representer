"""Functions to prevent a nuclear meltdown."""

def placeholder_0(placeholder_1: int | float, placeholder_2: int | float) -> bool:
    """Verify criticality is balanced.

    :param temperature: int or float - temperature value in kelvin.
    :param neutrons_emitted: int or float - number of neutrons emitted per second.
    :return: bool - is criticality balanced?

    A reactor is said to be critical if it satisfies the following conditions:
    - The temperature is less than 800 K.
    - The number of neutrons emitted per second is greater than 500.
    - The product of temperature and neutrons emitted per second is less than 500000.
    """
    return placeholder_1 < 800 and placeholder_2 > 500 and (placeholder_1 * placeholder_2 < 500000)

def placeholder_3(placeholder_4: int | float, placeholder_5: int | float, placeholder_6: int | float) -> str:
    """Assess reactor efficiency zone.

    :param voltage: int or float - voltage value.
    :param current: int or float - current value.
    :param theoretical_max_power: int or float - power that corresponds to a 100% efficiency.
    :return: str - one of ('green', 'orange', 'red', or 'black').

    Efficiency can be grouped into 4 bands:

    1. green -> efficiency of 80% or more,
    2. orange -> efficiency of less than 80% but at least 60%,
    3. red -> efficiency below 60%, but still 30% or more,
    4. black ->  less than 30% efficient.

    The percentage value is calculated as
    (generated power/ theoretical max power)*100
    where generated power = voltage * current
    """
    placeholder_7: int | float = placeholder_4 * placeholder_5
    placeholder_8: float = placeholder_7 / placeholder_6 * 100
    if placeholder_8 >= 80:
        return 'green'
    if placeholder_8 >= 60:
        return 'orange'
    if placeholder_8 >= 30:
        print(placeholder_8)
        return 'red'
    return 'black'

def placeholder_9(placeholder_1: int | float, placeholder_10: int | float, placeholder_11: int | float) -> str:
    """Assess and return status code for the reactor.

    :param temperature: int or float - value of the temperature in kelvin.
    :param neutrons_produced_per_second: int or float - neutron flux.
    :param threshold: int or float - threshold for category.
    :return: str - one of ('LOW', 'NORMAL', 'DANGER').

    1. 'LOW' -> `temperature * neutrons per second` < 90% of `threshold`
    2. 'NORMAL' -> `temperature * neutrons per second` +/- 10% of `threshold`
    3. 'DANGER' -> `temperature * neutrons per second` is not in the above-stated ranges
    """
    placeholder_12: int | float = placeholder_1 * placeholder_10
    match placeholder_12:
        case placeholder_1000 if placeholder_1000 < placeholder_11 * 0.9:
            return 'LOW'
        case placeholder_1000 if placeholder_1000 > placeholder_11 * 1.1:
            return 'DANGER'
        case _:
            return 'NORMAL'
