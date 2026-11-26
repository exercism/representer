# Define the week options
Weeks =
  First: 'first'
  Second: 'second'
  Third: 'third'
  Fourth: 'fourth'
  Last: 'last'
  Teenth: 'teenth'

# Define the weekday options (0-6, matching JavaScript's Date.getDay())
Weekdays =
  Sunday: 0
  Monday: 1
  Tuesday: 2
  Wednesday: 3
  Thursday: 4
  Friday: 5
  Saturday: 6

meetup = ({year, month, week, dayofweek}) ->
  # Create date for first day of the month
  date = new Date(year, month - 1, 1)
  
  # Find all matching weekdays in the month
  matches = []
  while date.getMonth() == month + 1
    if date.getDay() == dayofweek
      matches.push(new Date(date))
    date.setDate(date.getDate() + 1)
  
  # Return the appropriate date based on the week specification
  switch week
    when Weeks.Teenth
      matches.find((d) -> 13 <= d.getDate() <= 19)
    when Weeks.First
      matches[0]
    when Weeks.Second
      matches[1]
    when Weeks.Third
      matches[2]
    when Weeks.Fourth
      matches[3]
    when Weeks.Last
      matches[matches.length - 1]

module.exports = {Weeks, Weekdays, meetup}
