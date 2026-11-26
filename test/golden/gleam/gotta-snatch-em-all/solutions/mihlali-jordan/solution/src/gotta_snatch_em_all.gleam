import gleam/list
import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.new() |> set.insert(card)
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  case set.contains(collection, my_card), set.contains(collection, their_card) {
    True, False -> #(
      True,
      set.delete(collection, my_card)
        |> set.insert(their_card),
    )
    True, True -> #(False, set.delete(collection, my_card))
    False, _ -> #(False, set.insert(collection, their_card))
  }
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  case collections {
    [] -> []
    [first, ..rest] -> {
      let common =
        rest
        |> list.fold(first, set.intersection)
        |> set.to_list
        |> list.sort(string.compare)
      common
    }
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  collections
  |> list.fold(set.new(), set.union)
  |> set.size
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  collection
  |> set.filter(fn(card) { string.starts_with(card, "Shiny ") })
}
