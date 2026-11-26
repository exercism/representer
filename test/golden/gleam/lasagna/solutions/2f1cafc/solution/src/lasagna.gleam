pub fn expected_minutes_in_oven() {
  40
}

pub fn remaining_minutes_in_oven(used) {
  expected_minutes_in_oven() - used
}

pub fn preparation_time_in_minutes(count) {
  count * 2
}

pub fn total_time_in_minutes(count, used) {
  used + preparation_time_in_minutes(count)
}

pub fn alarm() {
  "Ding!"
}
