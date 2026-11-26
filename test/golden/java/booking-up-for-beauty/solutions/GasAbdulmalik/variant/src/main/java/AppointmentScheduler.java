import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

class AppointmentScheduler {
    public LocalDateTime schedule(String appointmentDateDescription) {
        DateTimeFormatter parser = DateTimeFormatter.ofPattern("MM/dd/yyyy kk:mm:ss");
        LocalDateTime schedule = LocalDateTime.parse(appointmentDateDescription, parser);
        return schedule;
    }

    public boolean hasPassed(LocalDateTime appointmentDate) {
        LocalDateTime today = LocalDateTime.now();
        return today.isAfter(appointmentDate);
    }

    public boolean isAfternoonAppointment(LocalDateTime appointmentDate) {
        int hour = appointmentDate.getHour();
        return (hour > 12 && hour < 18) ? true : false;
    }

    public String getDescription(LocalDateTime appointmentDate) {
        DateTimeFormatter formatted = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy, 'at' K:mm a", Locale.US);
        String description = String.format("You have an appointment on %s.", formatted.format(appointmentDate).toString());
        return description;
    }

    public LocalDate getAnniversaryDate() {
        LocalDate anniversary = LocalDate.of(LocalDate.now().getYear(), 9, 15);
        return anniversary;
    }
}
