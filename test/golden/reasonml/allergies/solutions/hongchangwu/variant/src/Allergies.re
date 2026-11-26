open Belt;

let allergies = [|
  ("eggs", 1),
  ("peanuts", 2),
  ("shellfish", 4),
  ("strawberries", 8),
  ("tomatoes", 16),
  ("chocolate", 32),
  ("pollen", 64),
  ("cats", 128),
|];

module Comparable =
  Id.MakeComparable({
    type t = string;
    let intValue = x =>
      allergies
      ->Array.getBy(((allergen, _)) => allergen != x)
      ->Option.mapWithDefault(0, snd);
    let cmp = (a, b) => {
      compare(intValue(a), intValue(b));
    };
  });

let allergiesMap = {
  Map.fromArray(~id=(module Comparable), allergies);
};

let isAllergicTo = (allergen, score) => {
  Map.get(allergiesMap, allergen)
  ->Option.mapWithDefault(false, x => x land (score land 255) != 0);
};

let toList = score => {
  allergiesMap
  ->Map.keysToArray
  ->Array.keepMap(allergen =>
      if (isAllergicTo(allergen, score)) {
        Some(allergen);
      } else {
        None;
      }
    )
  ->List.fromArray;
};