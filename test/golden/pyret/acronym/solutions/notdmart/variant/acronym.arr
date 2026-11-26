use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: abbreviate end

fun remove-punctuation(str :: String) -> String:
  str-list = string-split-all(str, "")
  punctionless-list = str-list.filter(
    lam(char) : 
          char-code = string-to-code-point(char)
          if (char-code == 32):
            true
          else if (char-code > 65) and (char-code <= 90):
            true
          else if (char-code >= 97) and (char-code <= 122):
            true
          else:
            false
          end
        end)
  fold(
    lam(builtWord :: String, word :: String): builtWord + word end,
    "",
    punctionless-list)
end

fun abbreviate(phrase :: String):
  hyphenless = string-replace(phrase, "-", " ")
  cleaned-phrase = remove-punctuation(hyphenless)
  all-words = filter(
    lam(str :: String): string-length(str) > 0 end,
    string-split-all(cleaned-phrase, " ")
    )
  acronym = fold(
    lam(acro :: String, word :: String) : acro + string-substring(word, 0,1) end,
    "",
    all-words
  )
  string-to-upper(acronym)
end
