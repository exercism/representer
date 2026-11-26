import java.time.{DayOfWeek, LocalDate}
import java.time.temporal.TemporalAdjusters

import Schedule.Schedule

case class Meetup(month: Int, year: Int) {

  def day(dayOfWeek: Int, schedule: Schedule): LocalDate = schedule match {
    case Schedule.First  => 
      LocalDate.of(year, month, 2).`with`(TemporalAdjusters.dayOfWeekInMonth(1, DayOfWeek.of(dayOfWeek)))
    case Schedule.Second => 
      LocalDate.of(year, month, 1).`with`(TemporalAdjusters.dayOfWeekInMonth(2, DayOfWeek.of(dayOfWeek)))
    case Schedule.Third  => 
      LocalDate.of(year, month, 1).`with`(TemporalAdjusters.dayOfWeekInMonth(3, DayOfWeek.of(dayOfWeek)))
    case Schedule.Fourth => 
      LocalDate.of(year, month, 1).`with`(TemporalAdjusters.dayOfWeekInMonth(4, DayOfWeek.of(dayOfWeek)))
    case Schedule.Teenth => 
      LocalDate.of(year, month, 13).`with`(TemporalAdjusters.nextOrSame(DayOfWeek.of(dayOfWeek)))
    case Schedule.Last   => 
      LocalDate.of(year, month, 1).`with`(TemporalAdjusters.lastInMonth(DayOfWeek.of(dayOfWeek)))
  }
}

object Schedule extends Enumeration {
  type Schedule = Value
  val Teenth, First, Second, Third, Fourth, Last = Value
}

object Meetup {
  val Mon = DayOfWeek.MONDAY.getValue
  val Tue = DayOfWeek.TUESDAY.getValue
  val Wed = DayOfWeek.WEDNESDAY.getValue
  val Thu = DayOfWeek.THURSDAY.getValue
  val Fri = DayOfWeek.FRIDAY.getValue
  val Sat = DayOfWeek.SATURDAY.getValue
  val Sun = DayOfWeek.SUNDAY.getValue
}
