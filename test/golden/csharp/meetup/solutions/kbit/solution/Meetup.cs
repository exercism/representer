using System;

public enum Schedule {
  Teenth,
  First,
  Second,
  Third,
  Fourth,
  Last
}

public class Meetup {
  private int Month { get; set; }
  private int Year { get; set; }

  public Meetup(int month, int year) {
    Month = month;
    Year = year;
  }

  public DateTime Day(DayOfWeek dayOfWeek, Schedule schedule) {
    var start = new DateTime(Year, Month, 1);
    var end = new DateTime(Year, Month, DateTime.DaysInMonth(Year, Month));

    return schedule switch {
      Schedule.Teenth => FindDay(dayOfWeek, start.AddDays(12)),
      Schedule.First => FindDay(dayOfWeek, start),
      Schedule.Second => FindDay(dayOfWeek, start.AddDays(7)),
      Schedule.Third => FindDay(dayOfWeek, start.AddDays(14)),
      Schedule.Fourth => FindDay(dayOfWeek, start.AddDays(21)),
      Schedule.Last => FindDay(dayOfWeek, end, true),
    };
  }

  private static DateTime FindDay(DayOfWeek dayOfWeek, DateTime start, bool backwards = false) {
    DateTime result = start;

    while (result.DayOfWeek != dayOfWeek) {
      result = result.AddDays(backwards ? -1 : 1);
    }

    return result;
  }
}
