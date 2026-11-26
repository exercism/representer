import gleam/int as i
import gleam/list as l

pub fn scores(high_scores: List(Int)) -> List(Int) {
  high_scores
}

pub fn latest(high_scores: List(Int)) -> Result(Int, Nil) {
  case high_scores {
    [] -> Error(Nil)
    [score] -> Ok(score)
    [_, ..tail] -> latest(tail)
  }
}

pub fn personal_best(high_scores: List(Int)) -> Result(Int, Nil) {
  high_scores |> l.sort(by: i.compare) |> latest()
}

pub fn personal_top_three(high_scores: List(Int)) -> List(Int) {
  case l.sort(high_scores, by: i.compare) {
    [] -> []
    [x] -> [x]
    [x, y] -> [y, x]
    [x, y, z] -> [z, y, x]
    [_, ..tail] -> personal_top_three(tail)
  }
}
