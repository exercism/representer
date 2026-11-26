using System;

static class Appointment
{
    public static DateTime Schedule(string appointmentDateDescription)
    {
        return Convert.ToDateTime(appointmentDateDescription);
    }

    public static bool HasPassed(DateTime appointmentDate)
    {
        DateTime date = DateTime.Now;
        return date > appointmentDate;
    }

    public static bool IsAfternoonAppointment(DateTime appointmentDate)
    {
        bool isAfternoon = (12 <= appointmentDate.Hour && appointmentDate.Hour < 18);
        return isAfternoon;
    }

    public static string Description(DateTime appointmentDate)
    {
        return "You have an appointment on " + appointmentDate.ToString() + ".";
    }

    public static DateTime AnniversaryDate()
    {
        DateTime date = DateTime.Now;
        return new DateTime(date.Year, 9, 15);
    }
}
