# Helper function to check if a date is a workday (Monday-Friday)
Function Is-Workday([datetime]$date) {
    # DayOfWeek enum: Sunday=0, Monday=1, ..., Saturday=6
    return $date.DayOfWeek -ge [DayOfWeek]::Monday -and $date.DayOfWeek -le [DayOfWeek]::Friday
}

# Helper function to find the first workday on or after a given date/time, preserving the time component.
Function Get-FirstWorkday([datetime]$startDate) {
    $currentDate = $startDate
    # Loop forward, adding one day at a time, until a workday is found
    while (-not (Is-Workday $currentDate)) {
        $currentDate = $currentDate.AddDays(1)
    }
    return $currentDate
}

# Helper function to find the last workday on or before a given date/time, preserving the time component.
Function Get-LastWorkday([datetime]$endDate) {
    $currentDate = $endDate
    # Loop backward, subtracting one day at a time, until a workday is found
    while (-not (Is-Workday $currentDate)) {
        $currentDate = $currentDate.AddDays(-1)
    }
    return $currentDate
}

Function Invoke-SwiftScheduling() {
    <#
    .SYNOPSIS
    Find the actual dates for deliveries.

    .DESCRIPTION
    Convert delivery date descriptions to actual delivery dates, based on when the meeting started.

    .PARAMETER MeetingStart
    A datetime object for the meeting start time.

    .PARAMETER Description
    A string describes the nature of the delivery date (e.g., "NOW", "ASAP", "EOW", "3M", "Q2").

    .EXAMPLE
    PS> Invoke-SwiftScheduling -MeetingStart (Get-Date "2025-03-10 10:00:00") -Description "ASAP"
    Monday, March 10, 2025 5:00:00 PM

    .EXAMPLE
    PS> Invoke-SwiftScheduling -MeetingStart (Get-Date "2025-03-14 09:00:00") -Description "EOW"
    Sunday, March 16, 2025 8:00:00 PM

    .EXAMPLE
    PS> Invoke-SwiftScheduling -MeetingStart (Get-Date "2025-03-10 10:00:00") -Description "6M"
    Monday, June 2, 2025 8:00:00 AM

    .EXAMPLE
    PS> Invoke-SwiftScheduling -MeetingStart (Get-Date "2025-08-10 10:00:00") -Description "Q2"
    Monday, June 29, 2026 8:00:00 AM
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [datetime]$MeetingStart,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $deliveryDate = $null # Initialize variable to store the result

    # Use a switch statement to handle different description types
    # -Regex allows matching patterns for variable descriptions
    switch -Regex ($Description) {
        "NOW" {
            # Delivery is exactly two hours after the meeting started
            $deliveryDate = $MeetingStart.AddHours(2)
        }
        "ASAP" {
            # Rule depends on the hour the meeting started
            if ($MeetingStart.Hour -lt 13) {
                # Before 1 PM: Deliver today at 5 PM (17:00)
                # .Date gets the date part only (time becomes 00:00:00)
                $deliveryDate = $MeetingStart.Date.AddHours(17)
            } else {
                # At or after 1 PM: Deliver tomorrow at 1 PM (13:00)
                $deliveryDate = $MeetingStart.Date.AddDays(1).AddHours(13)
            }
        }
        "EOW" {
            $startDay = $MeetingStart.DayOfWeek
            # Rule depends on the day of the week the meeting started
            if ($startDay -ge [DayOfWeek]::Monday -and $startDay -le [DayOfWeek]::Wednesday) {
                # Mon, Tue, or Wed: Deliver Friday of the same week at 5 PM (17:00)
                $daysUntilFriday = [int][DayOfWeek]::Friday - [int]$startDay
                $deliveryDate = $MeetingStart.Date.AddDays($daysUntilFriday).AddHours(17)
            } else {
                # Thursday or Friday: Deliver Sunday of the same week at 8 PM (20:00)
                # (Includes implicit handling for Sat/Sun starts if they were possible)
                # Calculate days needed to reach the *next* Sunday (0 if today is Sunday)
                 $daysUntilSunday = switch ($startDay) {
                        ([DayOfWeek]::Thursday) { 3 }
                        ([DayOfWeek]::Friday)   { 2 }
                        ([DayOfWeek]::Saturday) { 1 } # Assuming Sat follows Thu/Fri rule
                        ([DayOfWeek]::Sunday)   { 0 } # Sunday -> same day
                    }
                 # Check if switch returned a value (should always for Thu/Fri/Sat/Sun)
                 if ($daysUntilSunday -eq $null) {
                     throw "Internal error: Could not determine days until Sunday for EOW rule."
                 }
                $deliveryDate = $MeetingStart.Date.AddDays($daysUntilSunday).AddHours(20)
            }
        }
        "^(\d{1,2})M$" { # Matches <N>M pattern, capturing N (month number)
            $targetMonth = [int]$matches[1]
            # Validate the captured month number
            if ($targetMonth -lt 1 -or $targetMonth -gt 12) {
                throw "Invalid month number specified in '$Description'"
            }

            $targetYear = $MeetingStart.Year
            # If the meeting month is already >= the target month, schedule for next year
            if ($MeetingStart.Month -ge $targetMonth) {
                $targetYear++
            }

            # Set the initial target date to the 1st of the target month/year at 8 AM
            $firstDayOfMonth = try {
                 [datetime]::new($targetYear, $targetMonth, 1, 8, 0, 0)
            } catch {
                 throw "Failed to construct date for $targetYear-$targetMonth-01. Error: $($_.Exception.Message)"
            }

            # Find the first workday on or after this date
            $deliveryDate = Get-FirstWorkday $firstDayOfMonth
        }
        "^Q([1-4])$" { # Matches Q<N> pattern, capturing N (quarter number)
            $targetQuarter = [int]$matches[1]
            # Determine the quarter the meeting started in
            $currentQuarter = [math]::Ceiling($MeetingStart.Month / 3.0)

            $targetYear = $MeetingStart.Year
            # If the meeting quarter is already after the target quarter, schedule for next year
            if ($currentQuarter -gt $targetQuarter) {
                $targetYear++
            }

            # Calculate the last month of the target quarter (Q1->3, Q2->6, Q3->9, Q4->12)
            $lastMonthOfQuarter = $targetQuarter / 3
            # Calculate the number of days in that specific month and year (handles leap years)
            $lastDayOfMonth = try {
                 [datetime]::DaysInMonth($targetYear, $lastMonthOfQuarter)
            } catch {
                 throw "Failed to get days in month for $targetYear-$lastMonthOfQuarter. Error: $($_.Exception.Message)"
            }
            # Set the initial target date to the last day of the target quarter at 8 AM
            $lastDayOfQuarterTarget = try {
                 [datetime]::new($targetYear, $lastMonthOfQuarter, $lastDayOfMonth, 8, 0, 0)
            } catch {
                 throw "Failed to construct date for $targetYear-$lastMonthOfQuarter-$lastDayOfMonth. Error: $($_.Exception.Message)"
            }
            # Find the last workday on or before this date
            $deliveryDate = Get-LastWorkday $lastDayOfQuarterTarget
        }
        Default {
            # Handle any description that doesn't match the known patterns
            throw "Invalid description format provided: '$Description'"
        }
    }

    # Ensure a date was actually calculated (should be redundant due to Default switch case)
    if ($deliveryDate -eq $null) {
        throw "Failed to calculate delivery date for '$Description' - internal logic error."
    }

    # Return the final calculated delivery date and time
    return $deliveryDate
}