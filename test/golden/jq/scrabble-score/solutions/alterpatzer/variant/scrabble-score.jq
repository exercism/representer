def reverse_map(v; lets):
    lets | split("") | reduce .[] as $c ({}; .[$c] = (v | tonumber))
;

def letter_values:
    {"1": "AEIOULNRST",
     "2": "DG",
     "3": "BCMP",
     "4": "FHVWY",
     "5": "K",
     "8": "JX",
    "10": "QZ"} |
    to_entries |
    reduce .[] as {$key, $value} ({}; . + reverse_map($key; $value))
;

.word | ascii_upcase | split("") |
reduce .[] as $let (1; . + letter_values[$let])
