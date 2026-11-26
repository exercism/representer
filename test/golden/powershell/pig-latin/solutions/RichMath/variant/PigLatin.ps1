Function Invoke-PigLatin() {
    <#
    .SYNOPSIS
    Implement a program that translates from English to Pig Latin.

    .DESCRIPTION
    Pig Latin is a made-up children's language that's intended to be confusing.
    It obeys a few simple rules (below), but when it's spoken quickly it's really difficult for non-children (and non-native speakers) to understand.

    - **Rule 1**: If a word begins with a vowel sound, add an "ay" sound to the end of the word.
    Please note that "xr" and "yt" at the beginning of a word make vowel sounds (e.g. "xray" -> "xrayay", "yttria" -> "yttriaay").
    - **Rule 2**: If a word begins with a consonant sound, move it to the end of the word and then add an "ay" sound to the end of the word.
    Consonant sounds can be made up of multiple consonants, such as the "ch" in "chair" or "st" in "stand" (e.g. "chair" -> "airchay").
    - **Rule 3**: If a word starts with a consonant sound followed by "qu", move it to the end of the word, and then add an "ay" sound to the end of the word (e.g. "square" -> "aresquay").
    - **Rule 4**: If a word contains a "y" after a consonant cluster or as the second letter in a two letter word it makes a vowel sound (e.g. "rhythm" -> "ythmrhay", "my" -> "ymay").

    There are a few more rules for edge cases, and there are regional variants too.
    Check the tests for all the details.

    .PARAMETER Text
    A string represent a word or phrase in English.

    .EXAMPLE
    Invoke-PigLatin -Text "exercism"
    Returns: "exercismay"
    #>
    [CmdletBinding()]
    Param(
        [string]$Text
    )

    $vowels = 'aeiou'
    $consonants = 'bcdfghjklmnprstvwxz'     # q and y are special cases (omitted from this list)
    $letterclusters = "ch|qu|[$($consonants)]+qu|thr|th|sch"
    $specialletterclusters = "yt|xr"        # treated as a single vowel

    [array]$results = @()
    $Words = $Text -split "\s+"
    foreach($word in $words){
        Switch -regex ($word) {
            "^([$vowels]|$specialletterclusters)(.+)\b" {   Write-Verbose "Rule 1: $word"
                                                            $results += "{0}{1}ay" -f $matches[1],$matches[2]   # ay is added to words that start with vowels"
                                                            break
                                                        }
            "^([$consonants]+)(y.+)\b"                  {   Write-Verbose "Rule 4a: $word"
                                                            $results += "{0}{1}ay" -f $matches[2],$matches[1]
                                                            break
                                                        }
            "^($letterclusters+)(.+)\b"                 {
                                                            Write-Verbose "Rule 3: $word"
                                                            $results += "{0}{1}ay" -f $matches[2],$matches[1]
                                                            break
                                                        }
            "^([$consonants])(.+)\b"                    {   Write-Verbose "Rule 2: $word"
                                                            $results += "{0}{1}ay" -f $matches[2],$matches[1]   # first letter moved to the end followed by 'ay' if word start with consonants
                                                            break
                                                        }
#            "^($letterclusters+)(.+)\b"                 {   Write-Verbose "Rule 3: $word"
#                                                            $results += "{0}{1}ay" -f $matches[2],$matches[1]
#                                                            break
#                                                        }
            "^(.)y\b"                                   {   Write-Verbose "Rule 4b: $word"
                                                            $results += "y{0}ay" -f $matches[1]
                                                            $break
            }
            "^(q)([^u].+)\b"                            {     
                                                            Write-Verbose "Rule 5: $word"
                                                            $results += "{0}{1}ay" -f $Matches[2],$matches[2]   # first letter 'q' not followed by 'u'
                                                            break
                                                        }
            "^y(.+)\b"                                  {   Write-Verbose "Rule 6: $word"
                                                            $results += "{0}yay" -f $matches[1] # first letter is y, treat as a consonant
                                                            break
                                                        }
            default                                     {   Write-Verbose "EXCEPTION: $word"
                                                            break
                                                        }
        }
    }
    $results -join " "
}