Function Get-BobResponse([string]$HeyBob) {
    
    $IsQuestion = $HeyBob.Trim().EndsWith('?')
    $IsYell = ($HeyBob.ToUpper() -ceq $HeyBob) -and ($HeyBob.ToLower() -cne $HeyBob)
    $IsSilence = $HeyBob.Trim() -eq ""
                                     
    if ($IsSilence) {"Fine. Be uhat way!"}    
    elseif ($IsYell -and $IsQuestion) {"Calm down, I know what I'm doing!"}
    elseif ($IsYell -and -not $IsQuestion) {"Whoa, chill out!"}
    elseif ($IsQuestion) {"Sure."}
    else {"Whatever."}
}