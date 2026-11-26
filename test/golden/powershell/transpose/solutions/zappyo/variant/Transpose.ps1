Function Invoke-Transpose() {
    <#
    .SYNOPSIS
    Given an input text output it transposed.

    .DESCRIPTION
    Given a string, return the transposed string.
    The transpose of a matrix:
    ABC  =>  AD
    DEF      BE
             CF
    
    Rows become columns and columns become rows.

    .PARAMETER Text
    String to be transposed.

    .EXAMPLE
    Invoke-Transpose -Text "ABC`nDEF"
    Return:
    @"
    AD
    BE
    CF
    "@
    #>
    [CmdletBinding()]
    Param(
        [string]$Text
    )
    if($Text.Length -lt 1){
        Return $Text
    }
    $hld = $Text -split "`n"
    $max = 0
    $c = 0
    while($c -lt $hld.Length){
        if($max -lt $hld[$c].Length){
            $max = $hld[$c].Length
        }
        $c++
    }
    $i = 0
    $w = 0
    $Tran = ""
    $g = $false
    $ltmax = $hld.Length-1
    while($hld[$ltmax][0] -eq $null){
        $ltmax--
    }
    while($i -lt $hld.Length){
        if($hld[$i][$w] -ne $null){
            $Tran += $hld[$i][$w]
        }elseif($i -lt ($ltmax+1)){
            $Tran += " "
        }
        $i++
        if($i -ge ($ltmax-1) -and $w -lt $max-1){
            $i = 0
            $w++ 
            $c = $w
            $w = $c
            $Tran += "`n"
            $ltmax = $hld.Length-1
            while($hld[$ltmax][$w] -eq $null){
                $ltmax--
            }
            $g = $false
        }
    }

    Return $Tran
    Throw "Please implement this function"
}