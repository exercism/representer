import java.time.LocalDate;
import java.time.LocalDateTime;

public class Gigasecond {
    public static void main(String[] args){
        Gigasecond gigasecond=new Gigasecond(LocalDateTime.now());
        System.out.println(gigasecond.getDateTime());


    }
    LocalDateTime moment;



    public Gigasecond(LocalDate moment) {

        this.moment= moment.atStartOfDay();
    }

    public Gigasecond(LocalDateTime moment) {
        this.moment=moment;

    }

    public LocalDateTime getDateTime() {

     return moment.plusSeconds(1000000000);

    }
}

