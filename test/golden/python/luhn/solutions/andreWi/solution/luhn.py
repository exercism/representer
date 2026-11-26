# Inspired by IsaacG's solution
class Luhn:
    def __init__(self, card_num: str) -> None:
        self._num = card_num.replace(" ", "")
        self._valid = self._check_validity()

    def _check_validity(self) -> bool:
        if len(self._num) <= 1:
            return False

        if not self._num.isdigit():
            return False

        total = sum(int(digit) for digit in self._num)

        for digit in self._num[-2::-2]:
            d = int(digit)
            total += d - 9 if d * 2 > 9 else d

        return total % 10 == 0

    def valid(self) -> bool:
        return self._valid
