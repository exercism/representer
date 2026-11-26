use context essentials2020 # Don't delete this line when using Pyret on Exercism 

provide: color-code end

fun resistorColors() -> List<String>:
  doc: ```Returns a list of resistor colors in order of their corresponding codes.```
  [list: "black", "brown", "red", "orange", "yellow",
         "green", "blue", "violet", "grey", "white"]
end

fun indexOfColor(colorList :: List<String>, targetColor :: String) -> Number:
  doc: ```Returns the index of targetColor in colorList, or -1 if it's not found.```
  rec findIndex = lam(currentIndex :: Number) -> Number:
    ask:
      | currentIndex == colorList.length() then: -1
      | targetColor == colorList.get(currentIndex) then: currentIndex
      | otherwise: findIndex(currentIndex - 1)
    end
  end
  findIndex(0)
end

fun color-code(resistorColorList :: List<String>) -> Number:
  doc: ```Returns the code corresponding to the first two colors in resistorColorList.```
  resistorColorList
    .take(2)
    .map(lam(color): indexOfColor(resistorColors(), color) end)
    .foldl({(code, acc): (10 * acc) + code}, 0)
end
