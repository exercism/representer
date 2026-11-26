class Luhn:
    def __init__(self, card_num):
        self.card_num = card_num

    def valid(self):
        res = []
        card_num = [int(digit) for digit in self.card_num if digit.isnumeric()]
        if len(card_num) <= 1 or not "".join(self.card_num.split()).isdigit():
            return False
        else:
            card_num = card_num[::-1]
            for d in range(len(card_num)):
                if d % 2 != 0:
                    temp_res = card_num[d] * 2
                    res.append(temp_res+9 if temp_res > 9
                               else temp_res)
                else:
                    res.append(card_num[d])
        return sum(res) % 10 == 0

