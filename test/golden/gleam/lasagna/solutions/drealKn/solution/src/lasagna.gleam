pub fn expected_minutes_in_oven() {
  40
}

pub fn remaining_minutes_in_oven(time: Int) {
  expected_minutes_in_oven() - time
}

pub fn preparation_time_in_minutes(layers: Int) {
  layers * 2
}

pub fn total_time_in_minutes(layers: Int, time: Int) {
  preparation_time_in_minutes(layers) + time
}

pub fn alarm() {
  "Ding!"
}
