Function Get-Lyric() {
    <#
    .SYNOPSIS
    Recite the lyrics to that popular children's repetitive song: Ten Green Bottles.

    .DESCRIPTION
    Given a start bottles and a number of bottles to be taken away, return a string made of lyric from the song Ten Green Bottles.
    Note that not all verses are identical.

    .PARAMETER Start
    Number of bottles to start with, in range 1-10

    .PARAMETER Take
    Number of bottles to be taken away, in range 1-10
    Taken bottles can't be larger than starting bottles.

    .EXAMPLE
    Get-Lyric -Start 7
    Return:
    @"
    Seven green bottles hanging on the wall,
    Seven green bottles hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be six green bottles hanging on the wall.
    "@"
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [int]$Start,
        [int]$Take = 1
    )
    $sb = ""
    $tb = ""
    $rb = ""
    if($Start -lt 1){throw "Cannot validate argument on parameter 'Start'. The $Start argument is less than the minimum allowed range of 1. Supply an argument that is greater than or equal to 1 and then try the command again."}
    if($Take -gt $Start){throw "You can't take more bottle than what you started with."}
    if($Take -lt 0){throw "Cannot validate argument on parameter 'Take'. The $Take argument is less than the minimum allowed range of 1. Supply an argument that is greater than or equal to 1 and then try the command again."}
    while($Take -gt 0){
        switch($Start){
            1{$sb = "One"}
            2{$sb = "Two"}
            3{$sb = "Three"}
            4{$sb = "Four"}
            5{$sb = "Five"}
            6{$sb = "Six"}
            7{$sb = "Seven"}
            8{$sb = "Eight"}
            9{$sb = "Nine"}
            10{$sb = "Ten"}
            default{throw "Cannot validate argument on parameter 'Start'. The $Start argument is greater than the maximum allowed range of 10. Supply an argument that is less than or equal to 10 and then try the command again."}
        }
        $Start--
        switch($Start){
            0{$tb = "no"}
            1{$tb = "one"}
            2{$tb = "two"}
            3{$tb = "three"}
            4{$tb = "four"}
            5{$tb = "five"}
            6{$tb = "six"}
            7{$tb = "seven"}
            8{$tb = "eight"}
            9{$tb = "nine"}
            10{$tb = "ten"}    
        }
        if($Start -gt 1){$rb += "$sb green bottles hanging on the wall,`n$sb green bottles hanging on the wall,`nAnd if one green bottle should accidentally fall,`nThere'll be $tb green bottles hanging on the wall."}
        if($Start -eq 1){$rb += "$sb green bottles hanging on the wall,`n$sb green bottles hanging on the wall,`nAnd if one green bottle should accidentally fall,`nThere'll be $tb green bottle hanging on the wall."}
        if($Start -lt 1){$rb += "$sb green bottle hanging on the wall,`n$sb green bottle hanging on the wall,`nAnd if one green bottle should accidentally fall,`nThere'll be $tb green bottles hanging on the wall."}
        $Take--
        if($Take -gt 0){$rb += "`n`n"}
    }
    
   Return $rb

    

    
}
