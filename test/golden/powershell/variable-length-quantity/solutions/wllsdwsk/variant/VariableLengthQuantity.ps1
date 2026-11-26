Function Invoke-EncodeVLQ() {
    <#
    .SYNOPSIS
    Implement variable length quantity encoding

    .DESCRIPTION
    Given an array of integer values, encoding them using variable-length quantity technique to save spaces.

    .PARAMETER Bytes
    Array of data to be encoded.

    .EXAMPLE
    Invoke-EncodeVLQ -Bytes @(0x40)
    Returns: @(0x40)
    #>
    [CmdletBinding()]
    Param(
        [UInt32[]]$Bytes
    )
    foreach($x in $bytes){
        $vlq = [convert]::tostring($x,2)
		$segments = [math]::ceiling($vlq.length / 7)
        $vlq = $vlq.padleft(7 / $segments,'0') -split '(.{7})' -ne ""
        for($y = 0; $y -lt $vlq.length; $y++){
            $vlq[$y] = [string]$vlq[$y].padleft(7,'0')
            if($y -ne $vlq.length - 1){ $vlq[$y] = '1' + $vlq[$y] }
            else{ $vlq[$y] = '0' + $vlq[$y] }
            $vlq[$y] = [convert]::toint32($vlq[$y], 2)
        }
        $output += $vlq
    }
    return $output
}

Function Invoke-DecodeVLQ() {
    <#
    .SYNOPSIS
    Implement variable length quantity decoding.

    .DESCRIPTION
    Given an array of encoded integer values, decoding them to get the original values.

    .PARAMETER Bytes
    Array of data to be decoded.

    .EXAMPLE
    Invoke-DecodeVLQ -Bytes @(0x7F)
    Returns: @(0x7F)
    #>
    [CmdletBinding()]
    Param(
        [UInt32[]]$Bytes
    )
    foreach($x in $bytes){
        $x = [convert]::tostring($x,2).padleft(8,'0')
        $temp += ,$x
        if($x[0] -eq '0'){
            $binary += ,$temp
            $temp = @()
        }
    }
    if($temp -ne @()){ throw "*Incomplete sequence*" }
    $output = @()
    foreach($b in $binary){
        $temp = ""
        foreach($item in $b){
            $temp += $item[1..7] -join ""
        }
        $output += ,[convert]::toint64($temp,2)
    }
    return $output
}