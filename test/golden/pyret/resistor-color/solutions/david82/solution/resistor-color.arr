use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: color-code, colors end

fun colors() -> List<String>:
  [list: "black", "brown", "red", "orange", "yellow",
         "green", "blue", "violet", "grey", "white"]
end

fun find-index-in-list(target-list, target-element):
  doc: ```
    Find the index of target-element in target-list
    Returns -1 if target-element is not in target-list.
  ```
  rec find-target-index = lam(current-index):
    ask:
      | current-index == target-list.length() then: -1
      | target-element == target-list.get(current-index) then: current-index
      | otherwise: find-target-index(current-index + 1)
    end
  end
  find-target-index(0)
end

fun color-code(target-color :: String) -> Number:
  find-index-in-list(colors(), target-color)
end
