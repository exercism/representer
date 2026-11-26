import gleam/list

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  filter(list, predicate, [])
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  filter(list, fn(el) { !predicate(el) }, [])
}

fn filter(list, predicate, acc) {
  case list {
    [] -> list.reverse(acc)
    [el, ..list] -> {
      let acc =
        case predicate(el) {
          True -> [el, ..acc]
          False -> acc
        }
      filter(list, predicate, acc)
    }
  }
}