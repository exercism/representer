# input: null or an object that _may_ contain keys
#   actual_minutes_in_oven (default: 0)
#   number_of_layers (default: 1)

40 as $expected_minutes_in_oven
| ($expected_minutes_in_oven - (.actual_minutes_in_oven // 0)) as $remaining_minutes_in_oven
| ((.number_of_layers // 1) * 2) as $preparation_time
| ($preparation_time + (.actual_minutes_in_oven // 0)) as $total_time
| {
  $expected_minutes_in_oven,
  $remaining_minutes_in_oven,
  $preparation_time,
  $total_time
}
