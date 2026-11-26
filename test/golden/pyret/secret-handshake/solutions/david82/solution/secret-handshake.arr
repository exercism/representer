use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: commands end

# Global constant for actions, including a special action 'rev' to indicate reversal
ACTIONS :: List<String> = [list: "wink", "double blink", "close your eyes", "jump", "rev"]

# Converts a binary string to a list of actions based on the binary representation
fun commands(binary_input :: String) -> List<String>:
  # Use fold2 to iterate over each bit in the binary input and its corresponding action in ACTIONS
  fold2(
    lam(accumulated_actions :: List<String>, current_bit :: String, corresponding_action :: String) -> List<String>:
      ask:
        | current_bit == "0" then: 
          # Skip this action if the current bit is 0
          accumulated_actions
        | corresponding_action == "rev" then: 
          # Reverse the accumulated actions if the action is 'rev'
          accumulated_actions.reverse()
        | otherwise: 
          # Otherwise, add the current action to the accumulated list
          accumulated_actions + [list: corresponding_action]
      end
    end,
    [list:], # Start with an empty list to accumulate actions
    string-explode(binary_input).reverse(), # Process bits from least to most significant
    ACTIONS # List of actions corresponding to each bit
  )
end
