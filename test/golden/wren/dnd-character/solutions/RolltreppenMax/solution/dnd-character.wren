// export const abilityModifier = () => {
//   throw new Error('Remove this statement and implement this function');
// };
import "random" for Random



class Util {
  static abilityModifier(n) {
    if(n < 3) {
      Fiber.abort("Ability scores must be at least 3")
    }
    if(n > 18) {
      Fiber.abort("Ability scores can be at most 18")
    }
    return ((n - 10) / 2).floor
  }
}


class Character {
  construct new() {
    _strength = Character.rollAbility()
    _dexterity = Character.rollAbility()
    _charisma = Character.rollAbility()
    _constitution = Character.rollAbility()
    _hitpoints = 10 + Util.abilityModifier(_constitution)
    _intelligence = Character.rollAbility()
    _wisdom = Character.rollAbility()
  }
  static rollAbility() {
    var random = Random.new()
    var diceList = List.new()
    for (i in [0,1,2,3] ) {
        diceList.add(random.int(7))
    }
    diceList = diceList.sort()
    diceList.removeAt(0)
    var sum = 0
    for(n in diceList) {
      sum = sum + n
    }
    return 10 + Util.abilityModifier(sum)
  }

  strength { _strength }

  dexterity { _dexterity }

  constitution { _constitution }

  intelligence { _intelligence }

  wisdom { _wisdom }

  charisma { _charisma }

  hitpoints { _hitpoints }
}
