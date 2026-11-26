import gleam/result

pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  let game_with_rules_applied =
    game
    |> rule1
    |> result.filter(rule2)
    |> result.try(rule3)
    |> result.try(rule4)

  case game_with_rules_applied {
    Ok(new_game) -> {
      let new_player = case game.player {
        Black -> White
        White -> Black
      }
      Game(..new_game, player: new_player)
    }
    Error(err) -> Game(..game, error: err)
  }
}
