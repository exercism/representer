Function Invoke-Panagram() {
    <#
    .SYNOPSIS
    Determine if a sentence is a pangram.
    
    .DESCRIPTION
    A pangram is a sentence using every letter of the alphabet at least once.
    
    .PARAMETER Sentence
    The sentence to check
    
    .EXAMPLE
    Invoke-Panagram -Sentence "The quick brown fox jumps over the lazy dog"
    
    Returns: $true
    #>
    [CmdletBinding()]
    Param(
        [string]$Sentence
    )

    # Convert the sentence to lowercase for case-insensitive comparison
    $lowercaseSentence = $Sentence.ToLower()
    
    # The English alphabet has 26 letters (a-z)
    $alphabetCount = 26
    
    # Create a hashtable to track which letters have been found
    $letters = @{}
    
    # Check each character in the sentence
    foreach ($char in $lowercaseSentence.ToCharArray()) {
        # Check if the character is a letter (a-z)
        if ($char -ge 'a' -and $char -le 'z') {
            # Add the letter to our hashtable if it's not already there
            if (-not $letters.ContainsKey($char)) {
                $letters[$char] = $true
                
                # If we've found all 26 letters, we can return true immediately
                if ($letters.Count -eq $alphabetCount) {
                    return $true
                }
            }
        }
    }
    
    # If we've gone through the entire sentence and haven't found all letters,
    # then it's not a pangram
    return $letters.Count -eq $alphabetCount
}