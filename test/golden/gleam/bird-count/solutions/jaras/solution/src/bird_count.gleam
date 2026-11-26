pub fn today(days: List(Int)) -> Int {
  case days {
    [x, ..] -> x
    [] -> 0
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [x, ..rest] -> [x + 1, ..rest]
    [] -> [1]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [x, ..rest] -> x == 0 || has_day_without_birds(rest)
    [] -> False
  }
}

fn fold(list: List(a), acc: a, f: fn(a, a) -> a) {
  case list {
    [x, ..rest] -> fold(rest, f(acc, x), f)
    [] -> acc
  }
}

pub fn total(days: List(Int)) -> Int {
  fold(days, 0, fn(a, b) { a + b })
}

pub fn busy_days(days: List(Int)) -> Int {
  fold(
    days,
    0,
    fn(a, b) {
      let x = case b {
        x if x >= 5 -> 1
        _ -> 0
      }
      a + x
    },
  )
}
