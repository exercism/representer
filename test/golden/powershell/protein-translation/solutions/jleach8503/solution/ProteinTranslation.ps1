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

    $lookup = @{
        'AUG' = 'Methionine'
        'UUU' = 'Phenylalanine'
        'UUC' = 'Phenylalanine'
        'UUA' = 'Leucine'
        'UUG' = 'Leucine'
        'UCU' = 'Serine'
        'UCC' = 'Serine'
        'UCA' = 'Serine'
        'UCG' = 'Serine'
        'UAU' = 'Tyrosine'
        'UAC' = 'Tyrosine'
        'UGU' = 'Cysteine'
        'UGC' = 'Cysteine'
        'UGG' = 'Tryptophan'
        'UAA' = 'STOP'
        'UAG' = 'STOP'
        'UGA' = 'STOP'
    }

    $result = @()
    [regex]::Matches($Strand,'.{1,3}') | ForEach-Object {
        if ($lookup[$_.Value] -eq 'STOP') {
            break
        }
        elseif ($null -eq $lookup[$_.Value]) {
            $result
            throw 'error: Invalid codon'
        }
        else {
            $result += $lookup[$_.Value]
        }
    }
    $result
}
