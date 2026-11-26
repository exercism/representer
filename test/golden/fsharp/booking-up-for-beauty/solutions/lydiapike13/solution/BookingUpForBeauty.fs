module BookingUpForBeauty

// The following line is needed to use the DateTime type
open System

let schedule (appointmentDateDescription: string): DateTime =
    DateTime.Parse appointmentDateDescription

let hasPassed (appointmentDate: DateTime): bool =
    if appointmentDate < DateTime.Now then true
    else false

let isAfternoonAppointment (appointmentDate: DateTime): bool =
    if appointmentDate.Hour >= 12 && appointmentDate.Hour < 18 then true
    else false

let description (appointmentDate: DateTime): string =
    let strTime : string = appointmentDate.ToString("h:mm:ss tt")
    sprintf "You have an appointment on %d/%d/%d %s." appointmentDate.Month appointmentDate.Day appointmentDate.Year strTime

let anniversaryDate(): DateTime =
    let year : int = DateTime.Now.Year
    DateTime(year, 9, 15, 0, 0, 0)
