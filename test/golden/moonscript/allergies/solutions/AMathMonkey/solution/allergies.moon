all = {
  'eggs'
  'peanuts'
  'shellfish'
  'strawberries'
  'tomatoes'
  'chocolate'
  'pollen'
  'cats'
}

list = (score) ->
  [a for i, a in ipairs all when score & (1 << (i - 1)) > 0]

{
  allergic_to: (item, score) ->
    for a in *list(score)
      return true if a == item
    false
  :list
}
