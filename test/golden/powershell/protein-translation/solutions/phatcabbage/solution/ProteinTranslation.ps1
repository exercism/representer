Function Invoke-ProteinTranslation() {
    <#
    .SYNOPSIS
    Translate RNA sequences into proteins.

    .DESCRIPTION
    Take an RNA sequence and convert it into condons and then into the name of the proteins in the form of a list.

    .PARAMETER Strand
    The RNA sequence to translate.

    .EXAMPLE
    Invoke-ProteinTranslation -Strand "AUG"
    #>
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    $protToSeq = @{
      "UUG" = "Leucine";
      "UGU" = "Cysteine";
      "UAC" = "Tyrosine";
      "UAA" = "STOP";
      "UGC" = "Cysteine";
      "UCA" = "Serine";
      "UCC" = "Serine";
      "UUA" = "Leucine";
      "UGG" = "Tryptophan";
      "UCG" = "Serine";
      "UAG" = "STOP";
      "UAU" = "Tyrosine";
      "UGA" = "STOP";
      "UCU" = "Serine";
      "UUU" = "Phenylalanine";
      "AUG" = "Methionine";
      "UUC" = "Phenylalanine"
    }

    function Get-Subsequences([string]$s) {
        for ($i = 0; $i -lt $s.Length; $i += 3) {
            $s.Substring($i, [math]::min(3, $s.Length - $i))
        }
    }

    if ($Strand) {
        foreach ($seq in (Get-Subsequences $Strand)) {
            $prot = $protToSeq[$seq]
            if ($prot -eq 'STOP') { break }
            elseif (-not $prot) { Throw "error: invalid codon" }
            else { $prot }
        }
    }
}
