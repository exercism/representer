# Suggestions for MoonScript

These are improvements to MoonScript's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **`!=` and `~=`.** `a != b` and `a ~= b` stay apart. MoonScript's parser keeps the operator as written, and its compiler writes both as Lua's `~=`. Writing `!=` as `~=` would make them the same.
- **`@x` and `self.x`.** `@count` and `self.count` stay apart, and so do `@` and `self`. The parser reads them differently, and the compiler writes the same Lua for both. A mentor might comment on the long form.
- **Statements with a condition after them.** `return x if done` and `if done then return x` stay apart, and so do `x unless y` and `unless y then x`. The parser reads the first of each pair as a decorated statement, and the compiler writes the same Lua for both.
- **`unless` and `if not`.** `unless a then b` and `if not a then b` stay apart. Writing `unless` as `if not` would make them the same.
- **`elseif` and `else if`.** `elseif b` and `else if b` stay apart, although both run the same way. Writing one as the other would make them the same.
- **Update assignments.** `x += 1` and `x = x + 1` stay apart. A mentor might comment on the long form.
- **Implicit return.** `-> return x` and `-> x` stay apart when `return` is the function's last statement. MoonScript returns the last expression of a function, so dropping that `return` would make them the same. A mentor might comment on the extra `return`.
- **Quoted keys.** `{"a": 1}`, `{["a"]: 1}` and `{a: 1}` stay apart, although they make the same table. Writing a quoted key that is a valid name as a name would make them the same.
- **Brackets around a command call.** `(type x) == "number"` and `type(x) == "number"` stay apart, because Inspector keeps the brackets around a call. The brackets only change a call that returns several values, and a comparison or arithmetic uses only the first one, so dropping them there would make the two the same.
- **Looping over a list.** `for x in *xs` and `for _, x in ipairs xs` stay apart. They loop the same way over a list, but a mentor might comment on either.
