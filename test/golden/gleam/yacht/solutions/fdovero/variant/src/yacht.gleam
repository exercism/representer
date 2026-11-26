import gleam/list
import gleam/set
import gleam/int

pub type Category {
  Ones
  Twos
  Threes
  Fours
  Fives
  Sixes
  FullHouse
  FourOfAKind
  LittleStraight
  BigStraight
  Choice
  Yacht
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category {
    Ones -> score_numbers(dice, 1)
    Twos -> score_numbers(dice, 2)
    Threes -> score_numbers(dice, 3)
    Fours -> score_numbers(dice, 4)
    Fives -> score_numbers(dice, 5)
    Sixes -> score_numbers(dice, 6)
    FullHouse -> score_fullhouse(dice)
    FourOfAKind -> score_four_of_kind(dice)
    LittleStraight | BigStraight -> score_straight(dice, category)
    Choice -> dice |> int.sum()
    Yacht -> score_yacht(dice)
    _ -> 0
  }
}

fn score_numbers(dices: List(Int), number: Int) -> Int {
  dices
  |> list.filter(fn(d) { d == number })
  |> list.length()
  |> fn (x) { x * number }
}

fn score_fullhouse(dices: List(Int)) -> Int {
  case list.sort(dices, int.compare) {
    [a, b, c, d, e] if {{ a == b && a == c && d == e} || { a == b && c == d && c == e}} && a != e-> int.sum(dices)
    _ -> 0
  }
}

fn score_four_of_kind(dices: List(Int)) -> Int {
  case dices |> list.sort(int.compare) {
    [a, b, c, d, _] if {a == b && b == c && c == d} -> a + b + c - d
    [_, b, c, d, e] if {b == c && c == d && d == e} -> b + c + d + e
    _ -> 0
  }
}

fn score_yacht(dices: List(Int)) -> Int {
  case set.from_list(dices) |> set.size() {
    1 -> 50
    _ -> 0
  }
}

fn score_straight(dices: List(Int), type_of_straight: Category) -> Int {
  case 
    set.from_list(dices) |> set.size(),
    dices |> list.sort(int.compare),
    dices |> list.sort(int.compare) |> list.reverse(),
    type_of_straight {
      5, [2, ..], [6, ..], BigStraight -> 30
      5, [1, ..], [5, ..], LittleStraight -> 30
      _, _, _, _-> 0
  }
}