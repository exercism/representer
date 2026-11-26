$opening = "This is "
$closing = "that Jack built."
$lines = @(
    "the house ",
    "the malt that lay in ",
    "the rat that ate ",
    "the cat that killed ",
    "the dog that worried ",
    "the cow with the crumpled horn that tossed ",
    "the maiden all forlorn that milked ",
    "the man all tattered and torn that kissed ",
    "the priest all shaven and shorn that married ",
    "the rooster that crowed in the morn that woke ",
    "the farmer sowing his corn that kept ",
    "the horse and the hound and the horn that belonged to "
)

function Get-Rhyme {
    [CmdletBinding()]
    param(
        [int]
        $Start,

        [int]
        $End
    )

    $verses = @()
    foreach ($verse in $Start..$End) {
        $verses += $opening +(-join $lines[($verse - 1)..0]) + $closing
    }

    $verses -join "`n"   
}
