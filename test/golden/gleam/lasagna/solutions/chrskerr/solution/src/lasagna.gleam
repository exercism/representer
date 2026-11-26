pub fn expected_minutes_in_oven() -> Int {
  40
}

pub fn remaining_minutes_in_oven(minutes_already_in_oven: Int) -> Int {
  expected_minutes_in_oven() - minutes_already_in_oven
}

// Please define the preparation_time_in_minutes function

pub fn preparation_time_in_minutes(count_layers: Int) -> Int {
  count_layers * 2
}

// Please define the total_time_in_minutes function

pub fn total_time_in_minutes(count_layers: Int, minutes_already_in_oven: Int) -> Int {
  preparation_time_in_minutes(count_layers) + minutes_already_in_oven
}

// Please define the alarm function

pub fn alarm () {
  "Ding!"
}