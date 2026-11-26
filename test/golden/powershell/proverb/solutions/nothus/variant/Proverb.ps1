    Function Get-Proverb() {
        <#
        .SYNOPSIS
        Given a list of inputs, generate the relevant proverb.
    
        .DESCRIPTION
        Take a list of inputs and output the full text of a proverbial rhyme base on those inputs.
    
        .PARAMETER Data
        The list of inputs to generate the proverb.
    
        .EXAMPLE
        Get-Proverb -Data @("nail", "shoe", "horse", "rider", "message", "battle", "kingdom")
    
        @"
        For want of a nail the shoe was lost.
        For want of a shoe the horse was lost.
        For want of a horse the rider was lost.
        For want of a rider the message was lost.
        For want of a message the battle was lost.
        For want of a battle the kingdom was lost.
        And all for the want of a nail.
        "@
        #>
        [CmdletBinding()]
        Param(
            [string[]]$Data
        )

        if (-not $Data) { return '' }

        $allForTheWantOf = "And all for the want of a {0}."
        $forThisLostThat = "For want of a {0} the {1} was lost.`r`n"

        if ($Data.count -eq 1) { return $allForTheWantOf -f $Data[0] }
    
        $poem = ''
        for ($i = 0; $i -lt $Data.Count - 1; $i++) {
            $poem += $forThisLostThat -f $Data[$i], $Data[$i - 1]
        }
        
        return $poem += $allForTheWantOf -f $Data[0]
}