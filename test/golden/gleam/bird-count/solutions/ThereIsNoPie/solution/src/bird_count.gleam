pub fn today(days: List(Int)) -> Int {
  case days {
    [count, ..] -> count
    [] -> 0
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [count, ..rest] -> [count + 1, ..rest]
    [] -> [1]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [0, ..] -> True
    [_, ..rest] -> has_day_without_birds(rest)
    [] -> False
  }
}

pub fn total(days: List(Int)) -> Int {
  case days {
    [count, ..rest] -> count + total(rest)
    [] -> 0
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  case days {
    [count, ..rest] if count >= 5 -> 1 + busy_days(rest)
    [_, ..rest] -> busy_days(rest)
    [] -> 0
  }
}
