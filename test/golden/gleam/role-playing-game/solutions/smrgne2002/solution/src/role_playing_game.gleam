
import gleam/option.{type Option, Some, None}
import gleam/int.{max}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health {
    0 -> Some(Player(..player, health: 100, mana: {
      case player.level > 9 {
        True -> Some(100)
        False -> None
      }
    }))
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    Some(mana) -> case mana {
      m if m < cost -> #(player, 0)
      m -> #(Player(..player, mana: Some(m - cost)), cost * 2)
    }
    None -> #(Player(..player, health: player.health - cost |> max(0)), 0)
  }
}