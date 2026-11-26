import gleam/list.{flat_map}
import gleam/string.{to_graphemes}

type Orientation { Initial Terminal }
type Style { Brace Square Paren }
type Bracket { Bracket(orientation: Orientation, style: Style) }

fn to_brack(grapheme: String) -> List(Bracket) {
  case grapheme {
    "{" -> [Bracket(orientation: Initial, style: Brace)]
    "[" -> [Bracket(orientation: Initial, style: Square)]
    "(" -> [Bracket(orientation: Initial, style: Paren)]
    "}" -> [Bracket(orientation: Terminal, style: Brace)]
    "]" -> [Bracket(orientation: Terminal, style: Square)]
    ")" -> [Bracket(orientation: Terminal, style: Paren)]
    _   -> []
  }
}

fn match_brackets(rest: List(Bracket), initial: List(Style)) -> Bool {
  case rest {
    []        -> initial == []
    [b, ..bs] -> case b.orientation {
        Initial  -> match_brackets(bs, [b.style, ..initial])
        Terminal -> case initial {
            []        -> False
            [i, ..is] -> i == b.style && match_brackets(bs, is)
          }
      }
  }
}

pub fn is_paired(value: String) -> Bool {
  value |> to_graphemes |> flat_map(to_brack) |> match_brackets([])
}
