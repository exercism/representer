Trim        ← ▽ ¬↥ ⇌ ∩\× ⊸⇌ ⊸∊" \t\n"
AllSpaces   ← =0 ⧻ Trim
LastQ       ← =@? ⊣
IsYell      ← × ⊃(≥1/↧|=1/↥) ±
IsYellQType ← + ⊃(×2 IsYell|LastQ)
Ans         ← {"Whatever." "Sure." "Whoa, chill out!" "Calm down, I know what I'm doing!"}

# Respond to a phrase as Bob would
# Response ? Phrase
HeyBob ← |1 ⨬(°□˜⊡ Ans IsYellQType | "Fine. Be that way!") ⊸AllSpaces
