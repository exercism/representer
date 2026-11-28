# Suggestions for Erlang

[`transition.md`](../../../lib/inspector/languages/erlang/transition.md) says how Inspector treats Erlang differently from Basic, which Erlang used before.
These are changes that could improve it.
None of them is made, because a change to Erlang's own behaviour needs the maintainers to decide it.

## Spellings that Erlang's compiler reads as the same

1. **Expand the solution's macros.** Erlang's preprocessor replaces `?LIMIT` with the code given in `-define(LIMIT, 10).` before the parser sees it, so `X > ?LIMIT` and `X > 10` compile to the same code. Today the macro stays a call to a macro. One golden solution (isogram) defines a macro.
2. **Write `?MODULE` as the module's name.** `?MODULE:f()` and `leap:f()` call the same function in the module `leap`.
3. **Write a character as its value.** `$\s` and `$ ` are the same character, and so are `$\n` and `$\12`. Today each character keeps its text.
4. **Read the octal and hexadecimal escapes.** `"\101"`, `"\x41"`, `"\x{41}"` and `"A"` are the same string. Today these escapes stay as they are written.
5. **Write a call to an imported function as a remote call.** After `-import(lists, [map/2]).`, `map(F, L)` calls `lists:map(F, L)`. The engine drops the import, so today the two calls stay apart.

## Equivalences for the maintainers to decide

6. **Drop the export lists.** Every solution exports what the tests use, so `-export([leap_year/1]).` and `-export([leap_year/1, helper/1]).` pass the same tests. Basic dropped `-export` and `-export_type`. Mentors do comment on `-compile(export_all)`, so that attribute would have to stay.
7. **Drop the attributes that can't change what a passing solution does.** `-spec`, `-type` used only in specs, `-doc`, `-moduledoc`, `-author` and `-vsn` make no difference to the tests. Mentors do sometimes comment on specs.
8. **Write an underscore variable used once as `_`.** `f(_Name) -> ok` and `f(_) -> ok` do the same. Today `_Name` is renamed and `_` stays, so the two stay apart.
9. **Sort a binary's type specifiers.** `<<X:8/integer-unsigned>>` and `<<X:8/unsigned-integer>>` mean the same, and so does leaving out a default such as `integer` or `unsigned`.
10. **Reorder the functions in the module.** The order of the functions makes no difference in Erlang. A Reorder stage could attach each `-spec` to its function and sort the functions, so that a helper defined before or after its caller gives the same representation.
11. **Sort and join the export lists.** `-export([a/1, b/0]).` and `-export([b/0]). -export([a/1]).` export the same functions. This only matters if the export lists stay (see 6).
12. **Write a list of characters as a string.** `"abc"` and `[$a, $b, $c]` are the same value, but the parser gives them different trees. Mentors do sometimes comment on the choice.
