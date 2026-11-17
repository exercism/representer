"""Functions to prevent a nuclear meltdown."""

def placeholder_0(placeholder_1, placeholder_2):
    """Verify criticality is balanced.

    :param temperature: int or float - temperature value in kelvin.
    :param neutrons_emitted: int or float - number of neutrons emitted per second.
    :return: bool - is criticality balanced?

    A reactor is said to be critical if it satisfies the following conditions:
    - The temperature is less than 800 K.
    - The number of neutrons emitted per second is greater than 500.
    - The product of temperature and neutrons emitted per second is less than 500000.
    """
    placeholder_3 = placeholder_1 * placeholder_2
    placeholder_4 = False
    if (placeholder_1 < 800 and placeholder_2 > 500) and placeholder_3 < 500000:
        placeholder_4 = True
    return placeholder_4

def placeholder_5(placeholder_6, placeholder_7, placeholder_8):
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
    placeholder_9 = placeholder_6 * placeholder_7
    placeholder_10 = placeholder_9 / placeholder_8 * 100
    placeholder_11 = 'unknown'
    if 80 <= placeholder_10 <= 100:
        placeholder_11 = 'green'
    elif 60 <= placeholder_10 < 80:
        placeholder_11 = 'orange'
    elif 30 <= placeholder_10 < 60:
        placeholder_11 = 'red'
    else:
        placeholder_11 = 'black'
    return placeholder_11

def placeholder_12(placeholder_1, placeholder_13, placeholder_14):
    """Assess and return status code for the reactor.

    :param temperature: int or float - value of the temperature in kelvin.
    :param neutrons_produced_per_second: int or float - neutron flux.
    :param threshold: int or float - threshold for category.
    :return: str - one of ('LOW', 'NORMAL', 'DANGER').

    1. 'LOW' -> `temperature * neutrons per second` < 90% of `threshold`
    2. 'NORMAL' -> `temperature * neutrons per second` +/- 10% of `threshold`
    3. 'DANGER' -> `temperature * neutrons per second` is not in the above-stated ranges
    """
    placeholder_3 = placeholder_1 * placeholder_13
    placeholder_15 = placeholder_3 / placeholder_14 * 100
    if placeholder_15 < 90:
        placeholder_16 = 'LOW'
    elif placeholder_15 <= 110:
        placeholder_16 = 'NORMAL'
    else:
        placeholder_16 = 'DANGER'
    return placeholder_16
