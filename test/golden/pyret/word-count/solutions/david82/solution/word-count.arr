use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: word-count end

include string-dict

fun string-is-alphabetic(character :: String) -> Boolean:
  doc: 'Determines if the one-character string is an ASCII letter.'
  (("A" <= character) and (character <= "Z")) or 
  (("a" <= character) and (character <= "z"))
end

fun string-is-numeric(character :: String) -> Boolean:
  doc: 'Is the one-character string a digit?'
  ("0" <= character) and (character <= "9")
end

fun string-is-non-word-character(character :: String) -> Boolean:
  doc: 'Is the character NOT a "word character" (letters or apostrophes)?'
  not(string-is-alphabetic(character) or (character == "'") or string-is-numeric(character))
end

fun trim-apostrophes(s :: String, x :: String) -> String:
  doc: "remove all xs from the start or end of a string"
  ask:
    | string-length(s) == 0 then: s
    | string-starts-with(s, x) then: trim-apostrophes(string-substring(s, 1, string-length(s)), x)
    | string-ends-with(s, x) then: trim-apostrophes(string-substring(s, 0, string-length(s) - 1), x)
    | otherwise: s
  end
end

fun word-count(phrase :: String) -> StringDict:
  block:
    words = parse-text-to-words(phrase)
    counts = [mutable-string-dict: ]
    for each(word from words):
      cases(Option) counts.get-now(word):
        | none => counts.set-now(word, 1)
        | some(n) => counts.set-now(word, n + 1)
      end
    end
    counts.freeze()
  end
end

fun parse-text-to-words(phrase :: String) -> List<String>:
  doc: "Extract the words from the phrase"
  rec parser = lam(state :: String, chars :: List<String>, word :: String, words :: List<String>) -> List<String>:
    cases(List) chars:
      | empty => 
          trimmed = trim-apostrophes(word, "'")
          if string-length(trimmed) == 0:
            words
          else:
            words + [list: trimmed]
          end
      | link(c, cs) =>
          if state == 'seeking':
            # Looking for the start of a word
            if string-is-non-word-character(c):
              parser(state, cs, word, words)
            else:
              parser('in-word', cs, string-to-lower(c), words)
            end
          else:
            # In a word
            if not(string-is-non-word-character(c)):
              parser(state, cs, word + string-to-lower(c), words)
            else:
              trimmed = trim-apostrophes(word, "'")
              if string-length(trimmed) == 0:
                parser('seeking', cs, '', words)
              else:
                parser('seeking', cs, '', words + [list: trimmed])
              end
            end
          end
    end
  end
  parser('seeking', string-explode(phrase), '', [list:])
end
