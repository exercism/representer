import std/math
import std/random
import std/sequtils
  
type
  Character* = object
    strength*: int
    dexterity*: int
    constitution*: int
    intelligence*: int
    wisdom*: int
    charisma*: int
    hitpoints*: int

randomize()

proc ability*: int =
  let dice = [rand(5), rand(5), rand(5), rand(5)];
  let (min, _) = minmax(dice);
  result = foldl(dice, a + b) + min + 3;

proc modifier*(n: int): int =
  result = floor((n - 10) / 2).toInt

proc initCharacter*: Character =
  let constitution = ability();
  let hitpoints = 10 + modifier(constitution);
  result = Character(
                     strength: ability(),
                     dexterity: ability(),
                     constitution: constitution,
                     intelligence: ability(),
                     wisdom: ability(),
                     charisma: ability(),
                     hitpoints: hitpoints,
  )
