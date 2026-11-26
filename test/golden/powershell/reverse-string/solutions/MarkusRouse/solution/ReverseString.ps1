Function Get-ReverseString($Forward) 
{
    $reverseString = "";
    for($i = $Forward.Length; $i -ge 0; $i--)
    {
        $reverseString += $Forward[$i];   
    }
    return $reverseString;
}
