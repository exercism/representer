import java.time.LocalDate
import java.time.temporal.ChronoUnit

class Gigasecond {

    static def add(moment) {
        if(moment instanceof LocalDate) {
            moment = moment.atTime(0, 0)
        }
        moment.plus(1000000001, ChronoUnit.SECONDS)
    }

}
