expected_minutes_in_oven <- \() 60
remaining_time_in_minutes <- \(m) 60-m
prep_time_in_minutes <- \(n) 2*n
elapsed_time_in_minutes <- \(n, m) m+prep_time_in_minutes(n)
