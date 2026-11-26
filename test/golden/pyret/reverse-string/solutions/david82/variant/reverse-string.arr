# Import essential libraries from the Pyret context
use context essentials2020 # Don't delete this line when using Pyret on Exercism 

# Make the `reversed` function available for testing and importing
provide: reversed end

# Define a function `reversed` that takes a string and returns its reverse
fun reversed(text :: String) -> String:
  doc: ```
    Explode the string into a list of characters
    Then, use `foldl` to iterate over this list from left to right
    In each iteration, prepend the current character to the accumulator
    This effectively reverses the string as it builds up the accumulator from an empty string
  ```
  string-explode(text).foldl({(reversedStringAccumulator, currentCharacter): 
                              reversedStringAccumulator - currentCharacter}, 
                             "")
end
