# Translate words from English to Pig Latin
# Translation ? Phrase

# Core transformation: apply regex, extract/rearrange groups, append "ay"
Latinify! ← ◇(/$"__ay")^0↘₁⊢regex

# Regex pattern fragments
VowelStart    ← "([aeiou]|xr|yt)"
ConsonantClus ← "([^aeiou]?qu|[^aeiou]+)"
AfterCluster  ← "([aeiouy]\\w*)"
RestOfWord    ← "(\\w*)"

# Rule definitions using fragments
VowelRule     ← Latinify!∘ $"^__$" VowelStart RestOfWord
ConsonantRule ← Latinify!⇌ $"^__$" ConsonantClus AfterCluster

# Apply first matching rule
TranslateWord ← ⍣(VowelRule|ConsonantRule)

# Main function: split words, transform, rejoin
Translate ← ⍜(°/$"_ _"|⍚TranslateWord)
