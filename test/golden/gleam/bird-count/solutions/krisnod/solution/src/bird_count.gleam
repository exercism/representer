import gleam/list

// return that how many birds visited today)
pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [today] -> today
    [today, ..] -> today
  }
}

// increase today's bird count by one
pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [today] -> [today + 1]
    [today, ..previous_days] -> [today + 1, ..previous_days]
  }
}

// was there any day when no birds has visited the garden
pub fn has_day_without_birds(days: List(Int)) -> Bool {
  days
  |> list.any(fn (bird_count) { bird_count == 0 })
}

// calculate the total number of visiting birds
pub fn total(days: List(Int)) -> Int {
  total_loop(days, 0)
}

// calculate the number of days when at least five birds have visited the garden
fn total_loop(days: List(Int), total_bird_count: Int) {
  case days {
    [] -> total_bird_count
    [bird_count] -> total_bird_count + bird_count
    [bird_count, ..rest_of_days] -> total_loop(rest_of_days, total_bird_count + bird_count)
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  busy_days_loop(days, 0)
}

fn busy_days_loop(days: List(Int), busy_days_count: Int) {
  case days {
    [] -> busy_days_count
    [bird_count] ->
      case bird_count {
        _ if bird_count >= 5 -> busy_days_count + 1
        _ -> busy_days_count
      }
    [bird_count, ..rest_of_days] ->
      case bird_count {
        _ if bird_count >= 5 -> busy_days_loop(rest_of_days, busy_days_count + 1)
        _ -> busy_days_loop(rest_of_days, busy_days_count)
      }
  }
}
