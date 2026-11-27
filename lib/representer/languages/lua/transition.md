# Lua's transition

This file says how the Lua outputs of this service differ from the tools they replace, and why.

## Representation

Lua had no representer of its own (there is no `exercism/lua-representer`), so Lua used Basic. Basic drops comments and the spaces between tokens, and keeps everything else as it is written, including line breaks.
Lua now has a representation of its own, which follows the decisions that apply to every language ([README.md](../../../../README.md#how-it-works) describes them).
These things change for Lua:

- The representer renames every name the solution defines, so two solutions that differ only in their names get the same representation. This includes the functions and fields set on a table, such as `M.two_fer` and `self.count`, and the names of fields in a table constructor. Basic kept every name.
- The representer reads the solution's syntax tree, so line breaks make no difference.
- Each string and number is written as its value, so `'you'`, `"you"` and `[[you]]`, and `0x1F` and `31`, are the same. `1` and `1.0` stay apart, because Lua reads one as an integer and the other as a float.
- Brackets that only group make no difference, and nor do the separators in a table constructor (`,` or `;`) or a lone `;`. The brackets around a call or `...` stay, because they keep only its first value.
- Lua's parser reads `function M.f(x)` as `M.f = function(x)`, `function M:f(x)` as `M.f = function(self, x)`, and `f "s"` as `f("s")`, so the representer gives each pair the same representation. `local function f` stays apart from `local f = function`.
- The representer drops `require` calls, as imports.
- A solution with a syntax error still gets Basic's representation, with Lua's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Lua solution again.

## Analysis

This service doesn't make Lua analyses yet, and Lua has no old analyzer to compare with.

## Snippet

Lua's snippet hasn't changed. It still comes from Basic's snippet, which removes the comments found by Rouge's Lua lexer.
