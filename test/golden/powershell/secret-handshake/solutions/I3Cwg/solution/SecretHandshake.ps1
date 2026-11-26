Function Invoke-SecretHandshake() {
    <#
    .SYNOPSIS
    Convert a number between 1 and 31 to a sequence of actions in the secret handshake.

    .DESCRIPTION
    The sequence of actions is chosen by looking at the rightmost five digits of the number once it's been converted to binary.
    Start at the right-most digit and move left.

    The actions for each number place are:
    00001 = wink
    00010 = double blink
    00100 = close your eyes
    01000 = jump
    10000 = Reverse the order of the operations in the secret handshake.
    
    .PARAMETER Number
    The value to be converted into a sequence of actions.

    .EXAMPLE
    Invoke-SecretHandshake -Number 2
    Returns: @("double blink")
     #>
    [CmdletBinding()]
    Param(
        [int]$Number
    )
    Function Convert-binary([int]$dec){
        [string]$bin=""
        while($dec -gt 0){
            $temp=$dec%2
            $bin = [string]$temp + $bin
            $dec = [math]::floor($dec / 2)
        }
        if ($bin -eq ""){
            $bin = "0"
        }
        return $bin
    }
    $result=@()
    $code = Convert-binary -dec $Number
    $code = $code.PadLeft(5, '0')
    $action =@("wink", "double blink", "close your eyes", "jump")
    foreach($i in 4..1){
        if($code[$i] -eq '1'){
            $result+=$action[4-$i]
        }
    }
    if($code[0] -eq '1'){
        $result = [System.Collections.ArrayList]@($result)
        $result.Reverse()
    }
    return $result
}