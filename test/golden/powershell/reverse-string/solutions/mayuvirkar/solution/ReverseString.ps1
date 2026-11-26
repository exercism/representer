Function Get-ReverseString {
    $reversed = ""
    
    for($i = $Forward.Length; $i -gt 0; $i--){
        $reversed += $Forward[$i - 1] # Use -1 as arrays are 0 based so $Forward.Length is 1 more than the last element index of the array
    }

    return $reversed
}
