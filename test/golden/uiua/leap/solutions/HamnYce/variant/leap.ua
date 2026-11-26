# Determine if a year is a leap year
# IsLeapYear ? Year
Leap ← |1 (
  ⊸(=0◿100)
  ⨬(=1◿4|=0◿400)
)
