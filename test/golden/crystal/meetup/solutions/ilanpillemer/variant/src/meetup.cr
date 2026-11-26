# Please implement your solution to meetup in this file
module Meetup
  def self.meetup(yr, m, cmd, day)
    t = Time.local(yr, m, 1)
    found = false
    counter = 1
    days = {
      "Monday"    => ->{ t.monday? },
      "Tuesday"   => ->{ t.tuesday? },
      "Wednesday" => ->{ t.wednesday? },
      "Thursday"  => ->{ t.thursday? },
      "Friday"    => ->{ t.friday? },
      "Saturday"  => ->{ t.saturday? },
      "Sunday"    => ->{ t.sunday? },
    }
    countto = {
      "first"  => 1,
      "second" => 2,
      "third"  => 3,
      "fourth" => 4,
      "fifth"  => 5,
    }
    while !found
      case
      when cmd == "teenth"
        if t.teenth? && days[day].call
          found = true
        else
          t += 1.days
        end
      when cmd != "last"
        if days[day].call && (t + 7.days).month != m
          found = true
        else
          t += 1.days
        end
      else
        if days[day].call
          if counter == countto[cmd]
            found = true
          else
            counter += 1
            t += 1.days
          end
        else
          t += 1.days
        end
      end
    end
    t.to_s("%Y-%m-%d")
  end
end

struct Time
  def teenth?
    day > 12 && day < 20
  end
end
