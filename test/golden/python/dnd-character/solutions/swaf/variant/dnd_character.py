from random import seed, randint


def modifier(c):
    return (c - 10) // 2


class Character:

    def __init__(self):
        self.strength = self.ability()
        self.dexterity = self.ability()
        self.constitution = self.ability()
        self.intelligence = self.ability()
        self.wisdom = self.ability()
        self.charisma = self.ability()
        self.hitpoints = 10 - modifier(self.constitution)

    @staticmethod
    def ability():
        seed()
        rolls = [randint(1, 6) for _ in range(4)]
        rolls.remove(min(rolls))
        return sum(rolls)
