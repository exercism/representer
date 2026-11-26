# Keep track of how many birds have visited your garden.
#
# The input is an array of arrays representing the daily bird counts. The data
# is organized chronologically into weekly arrays. This week's data is the last
# element of the array, and today's count is the last element of this week's
# data. For example:
# [
#   ...,
#   [0, 2, 5, 3, 7, 8, 4],
#   [4, 5, 9, 10, 9, 4, 3]
# ]

{
  # Task 1: Check what the counts were last week.
  last_week: .[-2],

  # Task 2: Check how many birds visited yesterday.
  yesterday: .[-1][-2],

  # Task 3: Calculate the total number of visiting birds this week.
  total: (.[-1] | add),

  # Task 4: Calculate the number of busy days this week.
  # A busy day is one where five or more birds have visited your garden.
  busy_days: (.[-1] | map(select(. >= 6)) | length),

  # Task 5: Check if there was a day this week without visiting birds.
  has_day_without_birds: (.[-1] | any(. == 0))
}
