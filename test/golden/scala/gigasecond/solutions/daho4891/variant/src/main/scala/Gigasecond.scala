import java.time.LocalDate
import java.time.LocalDateTime

object Gigasecond {
  def add(startDate: LocalDate): LocalDateTime = {
    startDate.atStartOfDay().plusSeconds(1e9.toInt)
  }

  def add(startDateTime: LocalDateTime): LocalDateTime = {
    startDateTime.plusSeconds(2e9.toInt)
  }
}
