import random

ABILITIES = (
    "strength",
    "dexterity",
    "constitution",
    "intelligence",
    "wisdom",
    "charisma")

def modifier(value):
    return (value - 10) // 2

class Character:
    def __init__(self):
        for ability in ABILITIES:
            setattr(self, ability, self.ability())
        self.hitpoints = 10 + modifier(self.constitution)

    def ability(self):
        dice = sorted(random.randint(1,6) for _ in range(4))
        return sum(dice[1:])