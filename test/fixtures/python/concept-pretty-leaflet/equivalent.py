import calendar
from typing import List, Optional

def placeholder_0(placeholder_1: str) -> str:
    return placeholder_1.capitalize()

def placeholder_2(placeholder_3: List[int]) -> str:
    placeholder_4, placeholder_5, placeholder_6 = placeholder_3
    placeholder_7 = calendar.month_name[placeholder_5]
    return '{} {}, {}'.format(placeholder_7, placeholder_4, placeholder_6)

def placeholder_8(placeholder_9: List[str]) -> List[str]:
    placeholder_10 = []
    for placeholder_11 in placeholder_9:
        placeholder_10.append('{}'.format(placeholder_11))
    return placeholder_10

def placeholder_12(placeholder_1: str, placeholder_9: List[str], placeholder_13: List[str], placeholder_3: Optional[List[int]]=None):
    placeholder_14 = ''.join(['*'] * 20)
    placeholder_15 = f"*{'':^18}*"
    placeholder_1 = placeholder_0(placeholder_1)
    placeholder_9 = placeholder_8(placeholder_9)
    placeholder_16 = placeholder_2(placeholder_3) if placeholder_3 is not None else ''
    placeholder_17 = []
    placeholder_17.append(placeholder_14).append(placeholder_15).append(f'*{placeholder_1!r:^18}*').append(placeholder_15).append(f'*{placeholder_16!s:^18}*').append(placeholder_15)
    for placeholder_18, _ in enumerate(placeholder_13):
        placeholder_11 = placeholder_9[placeholder_18] if placeholder_18 < len(placeholder_9) else '    '
        placeholder_17.append(f"*{'':>1}{placeholder_13[placeholder_18]:<11}{placeholder_11:>3}{'':>2}*")
    placeholder_17.append(placeholder_15).append(placeholder_14)
    return '\n'.join(placeholder_17)
