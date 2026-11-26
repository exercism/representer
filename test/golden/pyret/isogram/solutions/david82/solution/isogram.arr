use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: is-isogram end

fun is_ascii_alpha(character :: String) -> Boolean:
  doc: 'Determines if the one-character string is an ASCII letter.'
  (("A" <= character) and (character <= "Z")) or 
  (("a" <= character) and (character <= "z"))
end

fun is-isogram(phrase :: String) -> Boolean:
  # Convert phrase to lowercase, explode it into a list of characters, and filter out non-alphabet characters
  phraseList = phrase
      ^ string-to-lower(_)
      ^ string-explode(_)
      ^ filter(is_ascii_alpha, _)
  
  rec check_isogram = lam(remaining_chars :: List<String>, seen_chars :: Set<String>) -> Boolean:
    cases(List) remaining_chars:
      | empty => true
      | link(current_char, rest_of_chars) =>
          ask:
            | not(seen_chars.member(current_char)) then: check_isogram(rest_of_chars, seen_chars.add(current_char))
            | otherwise: false
          end
    end
  end
  check_isogram(phraseList, [set:])
end
