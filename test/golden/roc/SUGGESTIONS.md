# Suggestions for Roc

[`transition.md`](../../../lib/rosetta/languages/roc/transition.md) says how Rosetta treats Roc differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Roc's own behaviour needs the maintainers to decide it.
The counts come from the 35 golden solutions that parse.

## Spellings that mean the same

1. **Write a block with one expression as the expression.** `|year| { year % 4 == 0 }` and `|year| year % 4 == 0` give the same function. The compiler's parser keeps the braces as a block, so they stay apart today. 22 golden solutions use a block that holds only one expression.
2. **Write a field given by its name the same as the field given as `name: name`.** `{ x, y }` and `{ x: x, y: y }` build the same record. The parser gives the two spellings different nodes. 2 golden solutions use the shorter form.
3. **Write a pipe, a method call and a module call the same way.** `list |> List.len`, `list.len()` and `List.len(list)` call the same function. Mentors may comment on the style, so this needs a decision. 15 golden solutions use `|>`, 28 call a method with `.`, and 25 call a function through its module.
4. **Write `&&` and `and`, and `||` and `or`, the same way.** Older versions of Roc used `&&` and `||`, and newer ones use `and` and `or`. No golden solution uses `&&` or `||`, and 11 use `and` or `or`.
5. **Write an `if` branch with braces the same as one without.** `if a { b } else { c }` and `if a b else c` give the same result. 13 golden solutions have a branch without braces.
6. **Write a multiline string the same as a string with `\n`.** A string written with `\\` lines has the same value as one string with line breaks in it. Today they stay apart, because the parser gives them different nodes. 3 golden solutions use a multiline string.
7. **Write a number with a type as its value.** `5.U8` and `0x05.U8` are the same number, but Rosetta keeps the text of a number with a type. 1 golden solution writes a number with a type.

## Equivalences for the maintainers to decide

8. **Drop the type annotations.** Every golden solution keeps the annotations given in the exercise's stub, such as `is_leap_year : I64 -> Bool`. A solution that drops or changes one stays apart from the others. 35 golden solutions have annotations.
9. **Sort the definitions in a type's `.{ }` block and at the top of the file.** Their order makes no difference to the solution working. 35 golden solutions put their functions in a type's `.{ }` block.
10. **Sort the fields of records and the tags of tag unions.** Roc's records and tag unions don't depend on order, so `{ a: 1, b: 2 }` and `{ b: 2, a: 1 }` are the same record. 8 golden solutions build a record with more than one field, and 8 write a tag union with more than one tag.

## Names

11. **Keep the names fixed by the tests.** The tests import the type and call its functions by name, such as `Leap` and `is_leap_year`, so those names are the same in every solution, and renaming them only makes the output harder to read.
12. **Keep the names of type variables and tags apart from values.** The engine renames by text, so a type variable `a` and a value `a` get the same placeholder. This makes no difference to grouping, but it can make the output harder to read.
