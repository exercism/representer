proc abbreviate {phrase} {
    regsub -all {[^-a-zA-Z ]} $phrase "" phrase
    set words [split $phrase " -"]
    set firstLetters [list]
    foreach word $words {
        set firstLetter [string toupper [string index $word 0]]
        lappend firstLetters $firstLetter
    }
    return [join $firstLetters ""]
}