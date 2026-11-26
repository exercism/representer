using System;

static class Appointment
{
    public static DateTime Schedule(string appointmentDateDescription)
    {
        try{
            return DateTime.Parse(appointmentDateDescription);
        }
        catch{
            throw new NotImplementedException("Please implement the (static) Appointment.Schedule() method");
        }        
    }

    public static bool HasPassed(DateTime appointmentDate)
    {
        try{
            int timePassed = DateTime.Compare(appointmentDate, DateTime.Now);

            if(timePassed > 0)
            {
                return false;
            }
            else{
                return true;
            }                
        }
        catch{
            throw new NotImplementedException("Please implement the (static) Appointment.HasPassed() method");
        }
        
    }

    public static bool IsAfternoonAppointment(DateTime appointmentDate)
    {
        try{
            TimeSpan start = new TimeSpan(12, 0, 0);
            TimeSpan end = new TimeSpan(18, 0, 0);
            TimeSpan now = appointmentDate.TimeOfDay;

            if(start <= now && now < end)
            {
                return true;
            }                
            else {
                return false;
            }
        }
        catch{
            throw new NotImplementedException("Please implement the (static) Appointment.IsAfternoonAppointment() method");
        }        
    }

    public static string Description(DateTime appointmentDate)
    {
        try{
            string appointmentTime = $"You have an appointment on {appointmentDate}.";
            return appointmentTime;
        }
        catch{
            throw new NotImplementedException("Please implement the (static) Appointment.Description() method");
        }        
    }

    public static DateTime AnniversaryDate()
    {
        try{
            return new DateTime(DateTime.Now.Year, 9, 15);
        }
        catch{
            throw new NotImplementedException("Please implement the (static) Appointment.AnniversaryDate() method");
        }        
    }
}
