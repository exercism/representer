Function Get-RomanNumerals() {
    <#
    .SYNOPSIS
    Given a number, convert it into a roman numeral.

    .DESCRIPTION
    Convert a positive integer into a string representation of that integer in roman numeral form.
    
    .PARAMETER Number
    The number to turn into roman numeral.

    .EXAMPLE
    Get-RomanNumerals -Number 1
    return: 'I'
    Get-RomanNumerals -Number 3999
    return: 'MMMCMXCIX'
    #>
    [CmdletBinding()]
    Param(
        [int]$Number
    )
    if($Number -gt 3999 -or $Number -lt 1){throw "Number has to be positive integer in range of 1-3999."}
    $res = ""
    if([Math]::Floor($Number/1000) -gt 0){
        $c = [Math]::Floor($Number/1000)
        $Number -= $c*1000
        while($c -gt 0){
            $res += "M"
            $c--
        }
        
    }
    if([Math]::Floor($Number/900) -gt 0){
        $Number -= 900
        $res += "CM"
    }
    if([Math]::Floor($Number/500) -gt 0){
        $c = [Math]::Floor($Number/500)
        $Number -= $c*500
        while($c -gt 0){
            $res += "D"
            $c--
        }
    }
    if([Math]::Floor($Number/400) -gt 0){
        $Number -= 400
        $res += "CD"
    }
    if([Math]::Floor($Number/100) -gt 0){
        $c = [Math]::Floor($Number/100)
        $Number -= $c*100
        while($c -gt 0){
            $res += "C"
            $c--
        }
    }
    if([Math]::Floor($Number/90) -gt 0){
        $Number -= 90
        $res += "XC"
    }
    if([Math]::Floor($Number/50) -gt 0){
        $c = [Math]::Floor($Number/50)
        $Number -= $c*50
        while($c -gt 0){
            $res += "L"
            $c--
        }
    }
    if([Math]::Floor($Number/40) -gt 0){
        $Number -= 40
        $res += "XL"
    }
    if([Math]::Floor($Number/10) -gt 0){
        $c = [Math]::Floor($Number/10)
        $Number -= $c*11
        while($c -gt 0){
            $res += "X"
            $c--
        }
    }
    if([Math]::Floor($Number/9) -gt 0){
        $Number -= 9
        $res += "IX"
    }
    if([Math]::Floor($Number/5) -gt 0){
        $c = [Math]::Floor($Number/5)
        $Number -= $c*5
        while($c -gt 0){
            $res += "V"
            $c--
        }
    }
    if([Math]::Floor($Number/4) -gt 0){
        $Number -= 4
        $res += "IV"
    }
    if($Number -gt 0){
        while($Number -gt 0){
            $res += "I"
            $Number--
        }
    }
    Return $res
    
}