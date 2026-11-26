# The input data is an array of arrays; each subarray represents a week and
# each element of each subarray represents the number of birds that visited on
# a given day. The weeks and days are ordered chronologically such that more
# recent data appear at the end of the arrays.
{
    # Task 1: last week's data
    last_week: nth(-2),
    
    # Task 2: this week's data
    yesterday: last | nth(-2),
    
    # Task 3: number of birds this week
    total: last | add,
    
    # Task 4: number of days with 5 or more birds this week
    busy_days: [last[] | select(5 <= .)] | length,
    
    # Task 5: whether any day this week had zero birds
    has_day_without_birds: last | any(. == 0)
}
