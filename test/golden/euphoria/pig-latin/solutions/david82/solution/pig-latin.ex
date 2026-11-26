include std/regex.e
include std/text.e
include std/sequence.e as seq

-- Callback function for regex replacement
function replace_with_pig_latin(sequence regex_match)
  return regex_match[3] & regex_match[2] & "ay"
end function

-- Main function to translate a word to Pig Latin
public function translate_word(sequence word)
  -- Improved regex pattern
  regex pattern = new(`([^aeioquxy ]*(?:qu|q|x|y)?)([aeiouxy]\w*)`)
  
  -- Apply translation
  return find_replace_callback(pattern, word, routine_id("replace_with_pig_latin"))
end function

-- Main function to translate a phrase to Pig Latin
public function translate(sequence input_phrase)
  -- Convert input to lowercase for consistency
  input_phrase = lower(input_phrase)
  
  -- Split input phrase into words
  sequence words = seq:split(input_phrase, " ")
  sequence translated_words = {}
  
  -- Translate each word in the phrase
  for i = 1 to length(words) do
    translated_words &= {translate_word(words[i])}
  end for
  
  -- Join translated words into a single phrase
  return seq:join(translated_words, " ")
end function
