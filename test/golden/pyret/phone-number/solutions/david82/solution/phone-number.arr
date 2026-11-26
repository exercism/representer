use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: clean end

import lists as L

fun is-letter(character :: String) -> Boolean:
  doc: 'Is the one-character string an ASCII letter?'
  (("A" <= character) and (character <= "Z")) or
  (("a" <= character) and (character <= "z"))
end

fun is-punctuation(character :: String) -> Boolean:
  doc: 'Is the one-character string an ASCII punctuation character?'
  (("!" <= character) and (character <= "/")) or
  ((":" <= character) and (character <= "@")) or
  (("[" <= character) and (character <= "`")) or
  (("{" <= character) and (character <= "~"))
end

fun string-remove-all(s :: String, cs :: List<String>) -> String:
  doc: "Remove all the characters in list cs from string s"
  string-explode(s)
  ^ filter({(c): not(cs.member(c))}, _)
  ^ L.join-str(_, '')
end

fun clean(phoneNumber :: String) -> String:
  # remove valid non-digits
  sanitizedPhoneNumber = string-remove-all(phoneNumber, [list: '(', ')', ' ', '-', '.'])
  
  # validating length
  digitList = string-explode(
        ask:
          | string-length(sanitizedPhoneNumber) < 10 then: raise("must not be fewer than 10 digits")
          | string-length(sanitizedPhoneNumber) == 10 then: sanitizedPhoneNumber
          | string-length(sanitizedPhoneNumber) == 11 then:
              ask:
                | string-starts-with(sanitizedPhoneNumber, "1") then: string-substring(sanitizedPhoneNumber, 1, 11)
                | otherwise: raise("11 digits must start with 1")
              end
          | (string-length(sanitizedPhoneNumber) == 12) and string-starts-with(sanitizedPhoneNumber, "+1") then: string-substring(sanitizedPhoneNumber, 2, 12)
          | otherwise: raise("must not be greater than 11 digits")
        end
      )
  
  # validating content
  ask:
    | digitList.any({(x): is-letter(x)}) then: raise("letters not permitted")
    | digitList.any({(x): is-punctuation(x)}) then: raise("punctuations not permitted")
    | digitList.get(0) == "0" then: raise("area code cannot start with zero")
    | digitList.get(0) == "1" then: raise("area code cannot start with one")
    | digitList.get(3) == "0" then: raise("exchange code cannot start with zero")
    | digitList.get(3) == "1" then: raise("exchange code cannot start with one")
    | otherwise: L.join-str(digitList, '')
  end
end
