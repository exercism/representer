module DndCharacter


open System

let modifier x =
    (float x - 10.0) / 2.0 |> floor |> int

let ability() = 
    let throws = [ for _ in 1 .. 4 -> Random().Next(1,7) ]
    List.sum throws + List.min throws
    

// TODO: define the Character type
type Character = {
    Strength : int
    Dexterity : int
    Constitution : int
    Intelligence : int
    Wisdom : int
    Charisma : int
    Hitpoints : int
}

let createCharacter() =
    let strength = ability()
    let dexterity = ability()
    let constitution = ability()
    let intelligence = ability()
    let wisdom = ability()
    let charisma = ability()
    let hitpoints = 10 + (modifier constitution)
    {
    Strength = strength
    Dexterity = dexterity
    Constitution = constitution
    Intelligence = intelligence
    Wisdom = wisdom
    Charisma = charisma
    Hitpoints = hitpoints
    }
