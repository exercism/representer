import gleam/list
import gleam/bool.{guard}

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  filter(list, predicate, [])
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(x) { !predicate(x) })
}

fn filter(list: List(t), predicate: fn(t) -> Bool, acc: List(t)) -> List(t) {
  case list {
    [] -> list.reverse(acc)
    [h, ..t] -> {
      use <- guard(predicate(h), filter(t, predicate, [h, ..acc]))
      filter(t, predicate, acc)
    }
  }
}
