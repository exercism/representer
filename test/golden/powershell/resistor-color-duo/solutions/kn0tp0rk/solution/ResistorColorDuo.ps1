Function Get-ColorCode($Color) {  
    @{
        #exercism has mispelled black on one of its tests
        #but it doesn't seem to matter
        "black" = 0
        "brown" = 1
        "red" = 2
        "orange" = 3
        "yellow" = 4
        "green" = 5
        "blue" = 6
        "violet" = 7
        "grey" = 8
        "white" = 9
    }[$Color]
}

Function Get-ColorCodeValue($Colors) {
    #Multiply first number by 10 and add second number
    (10 * (Get-ColorCode -Color $Colors[0])) + (Get-ColorCode -Color $Colors[1]) 
}