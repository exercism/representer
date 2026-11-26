import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

class Gigasecond(val localDate: LocalDateTime) {
    constructor(date: LocalDate) : this(date.atStartOfDay())

    val date: LocalDateTime = localDate.plusSeconds(1_000_000_000)
}
