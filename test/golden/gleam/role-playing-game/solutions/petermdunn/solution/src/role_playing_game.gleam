//// A simple role-playing game

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/order.{Eq, Gt, Lt}

/// A player in the game
pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

/// Introduce a player, returning their name if they have one
pub fn introduce(player: Player) -> String {
  case player {
    Player(name: Some(name), ..) -> name
    _ -> "Mighty Magician"
  }
}

/// Revive a player, returning the revived player if they can be revived
pub fn revive(player: Player) -> Option(Player) {
  case player.health {
    0 ->
      case int.compare(player.level, 10) {
        Gt | Eq -> Some(Player(..player, health: 100, mana: Some(100)))
        Lt -> Some(Player(..player, health: 100))
      }
    _ -> None
  }
}

/// Cast a spell, returning the player after casting and the damage dealt
pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    None -> #(Player(..player, health: int.max(0, player.health - cost)), 0)
    Some(mana) ->
      case int.compare(mana, cost) {
        Gt | Eq -> #(Player(..player, mana: Some(mana - cost)), cost * 2)
        Lt -> #(player, 0)
      }
  }
}
