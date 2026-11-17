"""Module-level docstring.

   Multi-line docstring style comment at
   the module level.
"""
import re
import operator
placeholder_0 = {'plus': operator.add, 'minus': operator.sub, 'multiplied by': operator.mul, 'divided by': operator.floordiv}
placeholder_1 = {'number': re.compile('-?\\d+'), 'operator': re.compile(f"(?:{'|'.join(placeholder_0.keys())})\\b")}

def placeholder_2(placeholder_3):
    placeholder_4 = placeholder_1['number'].match(placeholder_3)
    if not placeholder_4:
        raise ValueError('syntax error')
    return [placeholder_3.removeprefix(placeholder_4.group(0)).lstrip(), int(placeholder_4.group(0))]

def placeholder_5(placeholder_3):
    """Docstring style comment (should be removed)."""
    placeholder_4 = placeholder_1['operator'].match(placeholder_3)
    if not placeholder_4:
        raise ValueError('unknown operation')
    return [placeholder_3.removeprefix(placeholder_4.group(0)).lstrip(), placeholder_0[placeholder_4.group(0)]]

def placeholder_6(placeholder_3):
    """Mulit-line docstring.

        This is a multi-line comment in the style of a
        docstring. It should get removed in the representation.
    """
    placeholder_7 = placeholder_3.lower().strip().removesuffix('?')
    placeholder_8 = 'what is'
    if not placeholder_7.startswith(placeholder_8):
        raise ValueError('unknown operation')
    return placeholder_7.removeprefix(placeholder_8).lstrip()

def placeholder_9(placeholder_3):
    placeholder_7 = placeholder_6(placeholder_3)
    placeholder_7, placeholder_10 = placeholder_2(placeholder_7)
    while len(placeholder_7) > 0:
        if placeholder_1['number'].match(placeholder_7):
            raise ValueError('syntax error')
        placeholder_7, placeholder_11 = placeholder_5(placeholder_7)
        placeholder_7, placeholder_12 = placeholder_2(placeholder_7)
        placeholder_10 = placeholder_11(placeholder_10, placeholder_12)
    return placeholder_10
