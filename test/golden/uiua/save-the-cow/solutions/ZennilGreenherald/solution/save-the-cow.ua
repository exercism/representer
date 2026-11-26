MaskedWord ← |2 ⨬(⊂@@ ⍜⊏(⋅@_) ⊚ ¬/↥ ≡⌕ ⊙⊸¤|⊂@@ ˜▽ @_ ⋅⧻) ⊸(=0 ⧻)
TooManyGuesses ← |2 >9 /+ ¬˜∊
AllGuessed ← |2 ⨬(0|/× /↥ ≡⌕ ⊙¤) >0⊸⧻
State ← |2 ⨬("Lose"|"Ongoing"|"Win") × +1 ⊃(AllGuessed|¬TooManyGuesses)
ListDiff ← |2 ▽ ¬∊ ˜⊸∩(≡⊂ ≡□ ⊙≡□ ⊸⧆)
GuessesLeft ← |2 /↥ [0 ∘] ˜-9 ⧻ ListDiff

# Guess the word
# GameState | Guesses Word
Guess ← |2 {∘ ⊙∘ ⊙⊙∘} ⊃(State|MaskedWord|GuessesLeft)
