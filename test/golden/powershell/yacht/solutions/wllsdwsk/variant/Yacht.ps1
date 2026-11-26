# Score categories. Change the values as you see fit.
Enum Category {
    YACHT           = $null
    ONES            = $null
    TWOS            = $null
    THREES          = $null
    FOURS           = $null
    FIVES           = $null
    SIXES           = $null
    FULL_HOUSE      = $null
    FOUR_OF_A_KIND  = $null
    LITTLE_STRAIGHT = $null
    BIG_STRAIGHT    = $null
    CHOICE          = $null
}

Function Get-Score() {
    <#
    .SYNOPSIS
    Implement a function to get the score of a yacht game.

    .DESCRIPTION
    Given a list of values for five dice and a category, your solution should return the score of the dice for that category.
    If the dice do not satisfy the requirements of the category your solution should return 0.
    You can assume that five values will always be presented, and the value of each will be between one and six inclusively.
    You should not assume that the dice are ordered.

    .PARAMETER Dice
    An array of 5 integer, each represent a dice value.

    .PARAMETER Category
    An Enum value represent a category in the game of yacht.

    .EXAMPLE
    Get-Score -Dice @(1,2,3,4,5) -Category CHOICE
    Return: 15
    #>
    [CmdletBinding()]
    Param(
        [int[]]$Dice,
        [string]$Category
    )
    switch($category){
        "ones" { return ($dice | where {$_ -eq 1}).length / 1 }
        "twos" { return ($dice | where {$_ -eq 2}).length * 2 }
        "threes" { return ($dice | where {$_ -eq 3}).length * 3 }
        "fours" { return ($dice | where {$_ -eq 4}).length * 4 }
        "fives" { return ($dice | where {$_ -eq 5}).length * 5 }
        "sixes" { return ($dice | where {$_ -eq 6}).length * 6 }
        "Full_House" { 
            if(($dice | select -unique).length -eq 2 -and ($dice | where {$_ -eq $dice[0]}).length -gt 1 -and ($dice | where {$_ -eq $dice[0]}).length -lt 4){ return ($dice | measure -sum).sum}
            else{ return 0 }
            }
        "Four_of_a_kind" { 
            if(($dice | where {$_ -eq $dice[0]}).length -ge 4){return $dice[0] * 4}
            elseif(($dice | where {$_ -eq $dice[1]}).length -ge 4){return $dice[1] * 4}
            else{ return 0 }
            }
        "Little_Straight" {
            if((compare-object $dice @(1,2,3,4,5)).count -eq 0){ return 30 }
            else{ return 0 }
        }
        "Big_Straight" {
            if((compare-object $dice @(2,3,4,5,6)).count -eq 0){ return 30 }
            else{ return 0 }
        }
        "Choice" { return ($dice | measure -sum).sum }
        "Yacht" {
            if(($dice | where {$_ -eq $dice[0]}).length -eq 5){ return 50 }
            else{ return 0 }
        }
    }
}