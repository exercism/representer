<?php

function distance(string $strandA, string $strandB): int
{
    if(strlen($strandA) !== strlen($strandB)){
        throw new InvalidArgumentException('DNA strands must be of equal length.');
    } elseif (is_string($strandA)>=1 and is_string($strandB)>=1){
        $array_strand_a = str_split($strandA);
        $array_strand_b = str_split($strandB);
        $hamming = 0;

        for ($i=0; $i<count($array_strand_a); $i++){
            if($array_strand_a[$i] != $array_strand_b[$i]){
                $hamming+=1;
            }
        }
        return $hamming;
    }
}