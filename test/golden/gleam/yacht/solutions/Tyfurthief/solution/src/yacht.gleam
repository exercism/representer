import gleam/int
import gleam/list
import gleam/result

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

fn check_sum_on_specific_number(dice: List(Int), no: Int) -> Int {
  let total_count =
    dice
    |> list.count(fn(a) { a == no })

  no * total_count
}

fn check_full_house(dice: List(Int)) -> Int {
  let unique_dice =
    dice
    |> list.unique

  let unique_dice_length =
    unique_dice
    |> list.length

  let first_element =
    unique_dice
    |> list.first
    |> result.unwrap(0)

  let first_element_count =
    dice
    |> list.count(fn(a) { a == first_element })

  case
    unique_dice_length == 2
    && { first_element_count == 3 || first_element_count == 2 }
  {
    True -> int.sum(dice)
    False -> 0
  }
}

fn check_four_kind(dice: List(Int)) -> Int {
  let unique_dice =
    dice
    |> list.unique

  let unique_dice_length =
    unique_dice
    |> list.length

  let first_element =
    unique_dice
    |> list.first
    |> result.unwrap(0)

  let last_element =
    unique_dice
    |> list.last
    |> result.unwrap(0)

  let first_element_count =
    dice
    |> list.count(fn(a) { a == first_element })

  case { unique_dice_length == 2 || unique_dice_length == 1 } {
    True -> {
      case first_element_count {
        4 | 5 -> first_element * 4
        1 -> last_element * 4
        _ -> 0
      }
    }
    False -> 0
  }
}

fn little_straight(dice: List(Int)) -> Int {
  let sorted =
    dice
    |> list.sort(by: int.compare)

  case [1, 2, 3, 4, 5] == sorted {
    True -> 30
    _ -> 0
  }
}

fn big_straight(dice: List(Int)) -> Int {
  let sorted =
    dice
    |> list.sort(by: int.compare)

  case [2, 3, 4, 5, 6] == sorted {
    True -> 30
    _ -> 0
  }
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category {
    Ones -> {
      check_sum_on_specific_number(dice, 1)
    }
    Twos -> {
      check_sum_on_specific_number(dice, 2)
    }
    Threes -> {
      check_sum_on_specific_number(dice, 3)
    }
    Fours -> {
      check_sum_on_specific_number(dice, 4)
    }
    Fives -> {
      check_sum_on_specific_number(dice, 5)
    }
    Sixes -> {
      check_sum_on_specific_number(dice, 6)
    }
    FullHouse -> check_full_house(dice)
    FourOfAKind -> check_four_kind(dice)
    LittleStraight -> little_straight(dice)
    BigStraight -> big_straight(dice)
    Choice -> int.sum(dice)
    Yacht -> {
      let unique_dice =
        dice
        |> list.unique

      let unique_dice_length =
        unique_dice
        |> list.length

      case unique_dice_length == 1 {
        True -> 50
        False -> 0
      }
    }
  }
}
