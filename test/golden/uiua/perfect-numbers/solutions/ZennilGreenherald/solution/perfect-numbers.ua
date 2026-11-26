# Classify a positive integer based on its aliquot sum.
Aliquot ← /+× ◡˜(=0˜◿) ⊸(+1 ⇡ -1)
# Classification ? Number
ClassifyNumber ← |1 ⨬("number must be positive"|⨬("deficient"|"perfect"|"abundant") +1±˜-Aliquot) ⊸>0
