import groovy.time.TimeCategory
import java.time.ZoneId;
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Month

class Gigasecond {

    // YOUR CODE HERE
    // HINT: methods that don't change the state of an object can be 'static'
    static add(moment){
        if(moment.class != java.time.LocalDateTime){
            moment = moment.atStartOfDay()
            return moment.plusSeconds(10 ** 9)
        }
        else{
            return moment.plusSeconds(10 ** 9)
            
        }
    
    }
        
}


