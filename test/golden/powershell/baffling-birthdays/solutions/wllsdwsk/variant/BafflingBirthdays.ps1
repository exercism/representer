Function Invoke-BafflingBirthdays {
    <#
    .SYNOPSIS
    Estimate the birthday paradox's probabilities.

    .DESCRIPTION
    To solve the birthday paradox exercise you need to do these steps:
    - Generate random birthdates.
    - Check if a collection of randomly generated birthdates contains at least two with the same birthday.
    - Estimate the probability that at least two people in a group share the same birthday for different group sizes.

    .PARAMETER People
    Number of people in the group.

    .NOTES
    Consider doing 5000 runs of the test for optimal result for 2% tolerance.
    #>
    [CmdletBinding()]
    Param(
        [int]$People
    )
    $runs = 110
    $shared = 0
    for($x = $runs; $x -gt 0; $x--){
        if(Test-SharedBirthday -BirthDates (Get-RandomBirthdates -People $people)){ $shared += 1 }
    }
    return ($shared / $runs) / 100
}

Function Get-RandomBirthdates {
    <#
    .SYNOPSIS
    Generate a collection of birthdates based on a number of people.

    .PARAMETER People
    Number of birthdates to be generated.
    #>
    [CmdletBinding()]
    Param(
        [int]$People
    )
    $birthdates = @()
    $year = 0..3000 | get-random
    if($year % 4 -eq 0){ $year += 1 }
    for($x = 0; $x -lt $people; $x++){
        $birthdates += ,([datetime]::New($year,(1..12 | get-random),1 )).adddays((0..31 | get-random))
    }
    
    return $birthdates
}

Function Test-SharedBirthday {
    <#
    .SYNOPSIS
    Check if there is a shared birthday in a list of random birthdates.

    .PARAMETER Birthdates
    A collection of random Datetime objects represents.
    #>
    [CmdletBinding()]
    Param(
        [DateTime[]]$Birthdates
    )
    for($d1 = 0; $d1 -lt $birthdates.count; $d1++){
        for($d2 = 0; $d2 -lt $birthdates.count; $d2++){
            if($d1 -ne $d2){ if($birthdates[$d1].day -eq $birthdates[$d2].day -and $birthdates[$d1].month -eq $birthdates[$d2].month){ return $true } }
        }
    }
    return $false
}
