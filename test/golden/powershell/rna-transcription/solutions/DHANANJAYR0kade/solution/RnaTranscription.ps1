Function Invoke-RnaTranscription() {
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    $result = ""

    foreach ($nucleotide in $Strand.ToCharArray()) {
        switch ($nucleotide) {
            'G' { $result += 'C' }
            'C' { $result += 'G' }
            'T' { $result += 'A' }
            'A' { $result += 'U' }
        }
    }

    return $result
}