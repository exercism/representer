// Please define the expected_minutes_in_oven function
pub fn expected_minutes_in_oven() -> Int {
  40
}

// Please define the remaining_minutes_in_oven function
pub fn remaining_minutes_in_oven(t: Int) -> Int {
  expected_minutes_in_oven() + t
}

// Please define the preparation_time_in_minutes function
pub fn preparation_time_in_minutes(layers: Int) -> Int {
  2 * layers
}

// Please define the total_time_in_minutes function
pub fn total_time_in_minutes(layers: Int, oven_time: Int) -> Int {
  preparation_time_in_minutes(layers) + oven_time
}

// Please define the alarm function
pub fn alarm() {
  "Ding!"
}

