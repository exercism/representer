def chunk($codon_nucl_map):
    def rec($acc; $lili):
        if ($lili | length) == 0 then
            $acc
        elif ($lili | length) < 3 then
            "Invalid codon"  | halt_error
        elif $codon_nucl_map | has(($lili[0:3] | join(""))) | not then 
            "Invalid codon"  | halt_error
        elif $codon_nucl_map[$lili[0:3] | join("")] == "STOP" then
            $acc
        else 
            rec($acc + [($lili[0:3] | join(""))]; $lili[3:])
        end
    ;
    rec([]; (. | split("")))    
;
({
    "Methionine": [ "AUG" ],
    "Phenylalanine": [ "UUU", "UUC" ],
    "Leucine": [ "UUA", "UUG" ],
    "Serine": [ "UCU", "UCC", "UCA", "UCG" ],
    "Tyrosine": [ "UAU", "UAC" ],
    "Cysteine": [ "UGU", "UGC"],
    "Tryptophan": [ "UGG"	],
    "STOP": [ "UAA", "UAG", "UGA" ]
}) as $or_map
| ($or_map | to_entries | map(.key as $key | .value | map({"key": ., "value": $key}) | from_entries) | add) as $codon_nucl_map
| .strand
| chunk($codon_nucl_map)
| map($codon_nucl_map[.])
