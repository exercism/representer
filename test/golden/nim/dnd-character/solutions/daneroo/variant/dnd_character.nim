import std/[math, random, algorithm]

type
  Character* = object
    strength*, dexterity*, constitution*, intelligence*, wisdom*, charisma*, hitpoints*: int

proc modifier*(score: int): int =
  floor((score.float - 10) / 2).int

proc ability*(): int =
  var rolls: array[4, int]
  for i in 0..3:
    rolls[i] = rand(1..6)
  rolls.sort(order = Descending)
  result = rolls[0] + rolls[1] - rolls[2]

proc initCharacter*(): Character =
  randomize()
  result = Character(
    strength: ability(),
    dexterity: ability(),
    constitution: ability(),
    intelligence: ability(),
    wisdom: ability(),
    charisma: ability()
  )
  result.hitpoints = 10 + modifier(result.constitution)
