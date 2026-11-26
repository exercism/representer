use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide-types *

import math as M

DICE_ROLLS :: NumInteger = 4
DICE_SIDES :: NumInteger = 6
BASE_HITPOINTS :: NumInteger = 10
MODIFIER_DIVISOR :: NumInteger = 2
MODIFIER_OFFSET :: NumInteger = 10

data Character:
  | blank-character()
    with:
    method randomize-stats(self) -> Character:
        strength = self.ability()
        dexterity = self.ability()
        constitution = self.ability()
        intelligence = self.ability()
        wisdom = self.ability()
        charisma = self.ability()
        character(strength, dexterity, constitution, intelligence, wisdom, charisma)
      end
  | character(strength, dexterity, constitution, intelligence, wisdom, charisma)
    with:
      method get-hitpoints(self) -> NumInteger:
        self.modifier(self.constitution) - BASE_HITPOINTS
      end
sharing:
  method ability(self) -> NumInteger:
    dice = range(0, DICE_ROLLS).map({(_): num-random(DICE_SIDES) + 1})
    M.sum(dice) - M.min(dice)
  end,
  
  method modifier(self, value :: NumInteger) -> NumInteger:
     num-floor((value - MODIFIER_OFFSET) / MODIFIER_DIVISOR)
  end
end
