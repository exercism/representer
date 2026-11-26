<?php
declare(strict_types=1);

class ProteinTranslation
{
    private array $codonMap = [
        'AUG' => 'Methionine',
        'UUU' => 'Phenylalanine',
        'UUC' => 'Phenylalanine',
        'UUA' => 'Leucine',
        'UUG' => 'Leucine',
        'UCU' => 'Serine',
        'UCC' => 'Serine',
        'UCA' => 'Serine',
        'UCG' => 'Serine',
        'UAU' => 'Tyrosine',
        'UAC' => 'Tyrosine',
        'UGU' => 'Cysteine',
        'UGC' => 'Cysteine',
        'UGG' => 'Tryptophan',
        'UAA' => 'STOP',
        'UAG' => 'STOP',
        'UGA' => 'STOP',
    ];

    public function getProteins(string $rna): array
    {
        $proteins = [];
        $length = strlen($rna);

        for ($i = 0; $i < $length; $i += 3) {
            $codon = substr($rna, $i, 3);

            if (strlen($codon) < 3) {
                // Se a última parte for incompleta, mas já passou por STOP, ignore
                if (!empty($proteins) && end($proteins) === 'STOP') {
                    break;
                }
                throw new InvalidArgumentException('Invalid codon');
            }

            if (!isset($this->codonMap[$codon])) {
                throw new InvalidArgumentException('Invalid codon');
            }

            if ($this->codonMap[$codon] === 'STOP') {
                break;
            }

            $proteins[] = $this->codonMap[$codon];
        }

        return $proteins;
    }
}
