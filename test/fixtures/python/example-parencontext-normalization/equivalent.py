"""Examples of Parenthesized Context Managers. New feature in Python 3.10"""
from decimal import ROUND_DOWN, ROUND_UP, Decimal, localcontext
import pandas as placeholder_0

def placeholder_1(placeholder_2: placeholder_0.Series, placeholder_3: Decimal) -> placeholder_0.Series:
    """Calculates the fixed rate given trade data.

    Arguments
    ---------
    spot_price: pd.Series
        The spot price.
    position_duration: Decimal
        The position duration in seconds.

    Returns
    -------
    pd.Series
        The fixed interest rate.
    """
    with localcontext() as placeholder_4:
        placeholder_4.prec = 18
        placeholder_4.rounding = ROUND_UP
        placeholder_7 = placeholder_3 / Decimal(60 * 60 * 24 * 365)
    with localcontext() as placeholder_4:
        placeholder_4.prec = 18
        placeholder_4.rounding = ROUND_DOWN
        placeholder_8 = (1 - placeholder_2) / (placeholder_2 * placeholder_7)
    return placeholder_8
from argparse import ArgumentParser
import json

def placeholder_9():
    """convert json to jsonl"""
    placeholder_10 = placeholder_16()
    with open(placeholder_10.in_filename) as placeholder_11, open(placeholder_10.out_filename, mode='wt') as placeholder_13:
        placeholder_14 = json.load(placeholder_11)
        for placeholder_15 in placeholder_14:
            placeholder_13.write(json.dumps(placeholder_15) + '\n')

def placeholder_16():
    placeholder_17 = ArgumentParser()
    placeholder_17.add_argument('in_filename')
    placeholder_17.add_argument('out_filename')
    placeholder_10 = placeholder_17.placeholder_16()
    return placeholder_10
if __name__ == '__main__':
    placeholder_9()
