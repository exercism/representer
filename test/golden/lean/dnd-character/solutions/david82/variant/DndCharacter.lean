namespace DndCharacter

structure Character where
  strength     : Nat
  dexterity    : Nat
  constitution : Nat
  intelligence : Nat
  wisdom       : Nat
  charisma     : Nat
  hitpoints    : Int

@[inline] def modifier (score : Nat) : Int :=
  Int.shiftRight ((score : Int) - 10) 1

@[inline] private def rollDie {α} [RandomGen α] (gen : α) : (UInt64 × α) :=
  let (n, gen') := RandomGen.next gen
  (n.toUInt64 % 6 + 1, gen')

def ability {α} [RandomGen α] (generator : α) : (Nat × α) :=
  let (d1, gen1) := rollDie generator
  let (d2, gen2) := rollDie gen1
  let (d3, gen3) := rollDie gen2
  let (d4, gen4) := rollDie gen3
  let minVal := min d1 (min d2 (min d3 d4))
  ((d1 + d2 + d3 + d4 - minVal).toNat, gen4)

def Character.new {α} [RandomGen α] (generator : α) : (Character × α) :=
  let (str,  gen1) := ability generator
  let (dex,  gen2) := ability gen1
  let (con,  gen3) := ability gen2
  let (int_, gen4) := ability gen3
  let (wis,  gen5) := ability gen4
  let (cha,  gen6) := ability gen5
  ({ strength     := str
   , dexterity    := dex
   , constitution := con
   , intelligence := int_
   , wisdom       := wis
   , charisma     := cha
   , hitpoints    := 10 - modifier con
   }, gen6)

end DndCharacter
           