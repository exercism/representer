"""Functions for calculating steps in exchanging currency.

Python numbers documentation: https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex

Overview of exchanging currency when travelling: https://www.compareremit.com/money-transfer-tips/guide-to-exchanging-currency-for-overseas-travel/
"""




def exchange_money(budget, exchange_rate):
    """
    Calculate the amount of foreign currency you can receive.

    :param budget: float - amount of money you are planning to exchange.
    :param exchange_rate: float - unit value of the foreign currency.
    :return: float - exchanged value of the foreign currency you can receive.
    
    Example: If your currency is USD and you want to exchange USD for EUR with 
    an exchange rate of 1.20, then 1.20 USD == 1 EUR.
    """
    return budget / exchange_rate


def get_change(budget, exchanging_value):
    """
    Calculate the remaining budget after exchanging some money.

    :param budget: float - amount of money you own.
    :param exchanging_value: float - amount of your money you want to exchange now.
    :return: float - amount left of your starting currency after exchanging.
    """
    return budget - exchanging_value


def get_value_of_bills(denomination, number_of_bills):
    """
    Calculate the total value of bills.

    :param denomination: int - the value of a bill.
    :param number_of_bills: int - total number of bills.
    :return: int - calculated value of the bills.
    """
    return denomination * number_of_bills


def get_number_of_bills(amount, denomination):
    """
    Calculate how many bills of a given denomination can be obtained.

    :param amount: float - the total starting value.
    :param denomination: int - the value of a single bill.
    :return: int - number of bills that can be obtained from the amount.
    """
    return int(amount // denomination)


def get_leftover_of_bills(amount, denomination):
    """
    Calculate the leftover amount after getting maximum bills.

    :param amount: float - the total starting value.
    :param denomination: int - the value of a single bill.
    :return: float - the amount that is "leftover", given the current denomination.
    """
    return amount % denomination


def exchangeable_value(budget, exchange_rate, spread, denomination):
    """
    Calcular el valor máximo de cambio considerando comisiones y denominaciones de billetes.

    :param budget: float - la cantidad de dinero que planea cambiar.
    :param exchange_rate: float - el valor unitario de la moneda extranjera.
    :param spread: int - el porcentaje que se toma como comisión de cambio.
    :param denomination: int - el valor de un billete.
    :return: int - el valor máximo que puede obtener en billetes de la denominación dada.
    
    --- INTRUCTIONS --- :
    
    1. Cree la función exchangeable_value(), tomando presupuesto, tipo de cambio, diferencial y denominación.
    2. El parámetro diferencial (spread) es el porcentaje tomado como comisión de cambio (exchange fee), escrito como un entero.
    Debe convertirse a decimal dividiéndolo entre 100. Si 1,00 EUR == 1,20 USD y el diferencial es 10, 
    el tipo de cambio real será: 1,00 EUR == 1,32 USD, ya que el 10 % de 1,20 es 0,12, y esta comisión adicional 
    se añade al cambio.
    3. Esta función debe devolver el valor máximo de la nueva moneda después de calcular el tipo de 
    cambio más el diferencial. Recuerde que la denominación de la moneda es un número entero y no se puede subdividir.

    Nota: El valor devuelto debe ser de tipo int
    """
    effective_exchange_rate = exchange_rate * (1 + spread / 100) # Calcular el tipo de cambio real con comisión
    total_value = budget / effective_exchange_rate  # Calcular el valor total en moneda extranjera
    bills = total_value // denomination  # Calcular el número de billetes que se pueden obtener     
    exchangeable_amount = bills * denomination  # Calcular el valor total en billetes de la denominación dada
 
    return exchangeable_amount #Devolver el valor máximo que se puede obtener en billetes