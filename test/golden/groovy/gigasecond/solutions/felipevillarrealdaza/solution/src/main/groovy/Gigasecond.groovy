import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

class Gigasecond {

    static add(LocalDate moment){
        //Get LocalDate to Date, then to milliseconds
        long actualSeconds = Date.from(moment.atStartOfDay(ZoneId.systemDefault()).toInstant()).getTime();
        //Add the giga seconds in milliseconds
        long updatedSeconds = actualSeconds + 1000000000000
        //Create new Date in milliseconds
        Date updatedDate = new Date(updatedSeconds)
        //Return date as LocalDateTime
        return updatedDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }

    static add(LocalDateTime moment){
        //Get LocalDateTime to Date, then to milliseconds
        long actualSeconds = java.util.Date.from(moment.atZone(ZoneId.systemDefault()).toInstant()).getTime()
        //Add the giga seconds in milliseconds
        long updatedSeconds = actualSeconds + 1000000000000
        //Create new Date in milliseconds
        Date updatedDate = new Date(updatedSeconds)
        //Return date as LocalDateTime
        return updatedDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }

}
