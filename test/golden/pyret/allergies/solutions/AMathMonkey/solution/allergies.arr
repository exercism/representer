use context starter2024

include lists

provide-types *

data Allergies:
  | allergies(score :: Number) with:
    method allergicTo(self, allergen :: String) -> Boolean:
      self.list().member(allergen)
    end,
    method list(self) -> List<String>:
      allergens = [list: "eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"]
      fun recur(n :: Number, rest :: List<String>, acc :: List<String>) -> List<String>:
        ask:
          | num-is-non-positive(n) or is-empty(rest) then: acc.reverse()
          | num-modulo(n, 2) == 0 then: recur(num-truncate(n / 2), rest.drop(1), acc)
          | otherwise: recur(num-truncate(n / 2), rest.drop(1), acc.push(rest.get(0)))
        end
      end
      recur(self.score, allergens, empty)
    end
end
