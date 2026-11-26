
from random import randint

class Character:
    def __init__(self):
        self.strength = Character.ability(self)
        self.dexterity = Character.ability(self)
        self.constitution = Character.ability(self)
        self.intelligence = Character.ability(self)
        self.wisdom = Character.ability(self)
        self.charisma = Character.ability(self)
        self.hitpoints = get_hitpoints(self.constitution)

    def print_stats(self):
        """Print character stats to terminal"""
        print(f"Hitpoints: {self.hitpoints}")
        print(f"Strength: {self.strength}")
        print(f"Dexterity: {self.dexterity}")
        print(f"Constitution: {self.constitution}")
        print(f"Intelligence: {self.intelligence}")
        print(f"Wisdom: {self.wisdom}")
        print(f"Charisma: {self.charisma}")

    def ability(self):
        """Randomly generate a stat score by 'rolling' four dice, removing the lowest, and summing the rest"""
        rolled_dice = []
        for _ in range(1, 5):
            rolled_dice.append(randint(1, 6))
        rolled_dice.remove(min(rolled_dice))
        score = sum(rolled_dice)
        return score

def modifier(constitution):
    return (constitution - 10) // 2

def get_hitpoints(constitution):
    """Calculate character hitpoints from constitution"""
    return modifier(constitution) + 10

def create_character():
    """Generate a character with random stats"""
    my_character = Character()
    my_character.print_stats()


if __name__ == "__main__":
    create_character()
