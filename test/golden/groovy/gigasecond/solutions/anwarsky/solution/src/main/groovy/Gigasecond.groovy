import java.time.LocalDateTime
import java.time.LocalDate

class Gigasecond {
    static long GIGASECOND = 1_000_000_000
    // YOUR CODE HERE
    // HINT: methods that don't change the state of an object can be 'static'
    static LocalDateTime add(LocalDate moment) {
        add(moment?.atStartOfDay())    
    }
    static LocalDateTime add(LocalDateTime moment) {
        moment?.plusSeconds(GIGASECOND)        
    }
}
