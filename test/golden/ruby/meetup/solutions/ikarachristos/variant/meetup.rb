require "date"

class Meetup
  WEEK_DAYS = {
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  def initialize(month, year)
    @month = month
    @year = year
  end

  def day(day_of_week, variation)
    date = Date.new(@year, @month, 1)
    wday = WEEK_DAYS[day_of_week]

    candidates = []
    while date.month == @month
      candidates << date if date.cwday == wday
      date += 1
    end

    case variation
    when :first
      candidates[0]
    when :second
      candidates[1]
    when :third
      candidates[2]
    when :fourth
      candidates[3]
    when :last
      candidates[-1]
    when :teenth
      candidates.find { |c| c.day >= 12 && c.day < 20 }
    else
      candidates.first
    end
  end
end
