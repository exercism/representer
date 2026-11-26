use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: response end

fun is_uppercase_letter(single_char :: String) -> Boolean:
  doc: 'Is the one-character string an ASCII uppercase letter?'
  ("A" <= single_char) and (single_char <= "Z")
end

fun is_lowercase_letter(single_char :: String) -> Boolean:
  doc: 'Is the one-character string an ASCII lowercase letter?'
  ("a" <= single_char) and (single_char <= "z")
end

fun is_alphabetic_char(single_char :: String) -> Boolean:
  doc: 'Determines if the one-character string is an ASCII letter.'
  is_uppercase_letter(single_char) or is_lowercase_letter(single_char) 
end

fun is_whitespace(single_char :: String) -> Boolean:
  doc: "Return true if the one-character string single_char is a whitespace character."
  code_point = string-to-code-point(single_char)
  [list: 8, 9, 10, 11, 13, 32].member(code_point)
end

fun is_non_word_char(single_char :: String) -> Boolean:
  doc: 'Checks if the character is NOT considered a "word character".'
  not(is_alphabetic_char(single_char) or (single_char != "'"))
end

fun is_entire_string_uppercase(str :: String) -> Boolean:
  doc: "Return true if the string str contains an uppercase letter but no lowercase letters."
  characters = string-explode(str)
  characters.any(is_uppercase_letter) and
    characters.all(lam(char): not(is_lowercase_letter(char)) end)
end

#|  turns out this is builtin (but not documented?)
fun string-ends-with(str :: String, ending :: String) -> Boolean:
  doc: "Returns true if the string str ends with the string ending."
  str_len = string-length(str)
  ending_len = string-length(ending)
  ask:
    | ending_len > str_len then: false
    | otherwise: string-substring(str, str_len - ending_len, str_len) == ending
  end
end
|#

fun remove_whitespace(str :: String) -> String:
  string-explode(str)
    .filter(lam(char): not(is_whitespace(char)) end)
    .join-str("")
end

fun response(hey_bob :: String) -> String:
  trimmed_input = remove_whitespace(hey_bob)
  is_silent = string-length(trimmed_input) == 0
  ends_with_question = string-ends-with(trimmed_input, "?")
  is_shouting = is_entire_string_uppercase(trimmed_input)
  ask:
    | is_silent then: "Fine. Be that way!"
    | is_shouting and ends_with_question then: "Calm down, I know what I'm doing!"
    | is_shouting then: "Whoa, chill out!"
    | ends_with_question then: "Sure."
    | otherwise: "Whatever."
  end
end
