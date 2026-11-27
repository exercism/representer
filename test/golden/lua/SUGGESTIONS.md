# Suggestions for Lua

These are improvements to Lua's representation for the maintainers to discuss.
None of them is in the representer yet.

- **Fields written as strings.** `t.count` and `t["count"]` stay apart, and so do `{count = 0}` and `{["count"] = 0}`. Lua's parser reads each pair the same way, so writing the string key as a name would make them the same. The representer would then also rename a string key such as `"count"` wherever the solution defines `count`, which is a decision about names.
- **Local functions.** `local function f() ... end` and `local f = function() ... end` stay apart. They only behave differently if `f` calls itself, which the second spelling can't do. Making them the same would merge most solutions that use either spelling.
- **Explicit `nil`.** `local x` and `local x = nil` stay apart. Both give `x` the value `nil`, so dropping `= nil` from a local declaration would make them the same.
- **The order of table fields.** `{a = 1, b = 2}` and `{b = 2, a = 1}` stay apart. The order of named fields in a table constructor makes no difference, so sorting them would group solutions that list them in a different order, such as the colour codes in resistor-color-duo. Fields without a key must keep their order, because their position gives their index.
- **String methods.** `s:upper()` and `string.upper(s)` stay apart. They do the same thing when `s` is a string, but the representer can't tell whether `s` is one.
- **Negated comparisons.** `not (a == b)` and `a ~= b` stay apart. They are the same for numbers and strings, but a mentor might comment on the longer one.
- **Other escapes.** The representer reads `\n`, `\t`, `\r`, `\\`, `\"` and `\'`, the escapes used in the solutions. Reading `\ddd`, `\xXX`, `\u{XXX}` and `\z` too would make `"\65"` and `"A"` the same. None of the solutions uses them yet.
