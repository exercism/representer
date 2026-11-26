import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

class Gigasecond {
    static LocalDateTime add(LocalDate date) {
        return add(LocalDateTime.of(date, LocalTime.MIN))
    }

    static LocalDateTime add(LocalDateTime dateTime) {
        return dateTime.plus(Duration.ofSeconds(1000000000))
    }
}
