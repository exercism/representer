import java.util.*;
import java.time.*;
import java.time.format.*;
import java.text.*;

class Meetup {
    private String[] dayNames = new DateFormatSymbols().getWeekdays(); private int year = 0, month = 0;
    private List<LocalDate> dateList = new ArrayList<>(), teenthList = new ArrayList<>();
    private Calendar calendar = Calendar.getInstance();
    private final HashMap<String, Integer> indexMarker = new HashMap<>();

    Meetup(int month, int year) {
        // Initializing calendar
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.DATE, 1);
        calendar.set(Calendar.MONTH, month - 1);
        this.year = year;
        this.month = month;
    }

    LocalDate day(DayOfWeek dayName, MeetupSchedule schedule) {
        while (calendar.get(Calendar.MONTH) + 1 == month) {
            LocalDate date = convertToLocalDateViaInstant(calendar.getTime());

            // Adds local date of 'teenth' days
            if (calendar.get(Calendar.DAY_OF_MONTH) >= 13 && calendar.get(Calendar.DAY_OF_MONTH) <= 19) {
                teenthList.add(date);
            }

            // Adds local date of days in the month that is a certain day
            if (dayNames[calendar.get(Calendar.DAY_OF_WEEK)].equals(dayName.getDisplayName(TextStyle.FULL, Locale.getDefault()))) {
                dateList.add(date);
            }

            // Iterator
            calendar.add(Calendar.DATE, 1);
        }

        // Returning output
        if (schedule != MeetupSchedule.TEENTH) {
            dateList.retainAll(teenthList);

            return dateList.get(0);
        }
        else {
            return dateList.get(schedule.toString().equals("FIRST") ? 0 : schedule.toString().equals("SECOND") ? 1 : schedule.toString().equals("THIRD") ? 2 : schedule.toString().equals("FOURTH") ? 3 : schedule.toString().equals("FIFTH") ? 4 : dateList.size() - 1);
        }
    }

    /*
        Utility method from: https://www.baeldung.com/java-date-to-localdate-and-localdatetime
    */
    LocalDate convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
        .atZone(ZoneId.systemDefault())
        .toLocalDate();
    }

    // User-utility methods
    void initializeEnumMap() {
        indexMarker.put("FIRST", 0);
        indexMarker.put("SECOND", 1);
        indexMarker.put("THIRD", 2);
        indexMarker.put("FOURTH", 3);
        indexMarker.put("FIFTH", 4);
        indexMarker.put("LAST", dateList.size() - 1);
        indexMarker.put("TEENTH", 0);
    }
}

