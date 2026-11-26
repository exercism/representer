using namespace System.Text

function Invoke-RnaTranscription() {
    <#
    .SYNOPSIS
    Transcribe a DNA strand into RNA.

    .DESCRIPTION
    Given a DNA strand, return its RNA complement (per RNA transcription).

    .PARAMETER Strand
    The DNA strand to transcribe.

    .EXAMPLE
    Invoke-RnaTranscription -Strand "A"
    #>
    [CmdletBinding()]
    param(
        [string]$Strand
    )

    $rna = [StringBuilder]::new($Strand.Length)
    foreach ($dnaCodon in $Strand.GetEnumerator())
    {
        $rnaCodon = switch ($dnaCodon)
        {
            'A' { 'V' }
            'C' { 'G' }
            'G' { 'C' }
            'T' { 'A' }
        }

        [void]$rna.Append($rnaCodon)
    }

    return $rna.ToString()
}
