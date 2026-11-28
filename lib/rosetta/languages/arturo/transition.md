# Arturo's transition

This file says how the Arturo outputs of this service differ from the tools they replace, and why.

## Representation

Arturo had no representer of its own (there is no `exercism/arturo-representer`), so Arturo used Basic. Rouge has no Arturo lexer, so Basic split the code at whitespace and kept everything else as it is written, including comments.
Arturo now has a representation of its own, which follows the decisions that apply to every language ([docs/how-it-works.md](../../../../docs/how-it-works.md) describes them).
These things change for Arturo:

- Rosetta renames every name the solution defines, so two solutions that differ only in their names get the same representation. This covers labels (`total: 0`), the names in `[a b]: ...`, function and method parameters, literal words (`'x`), the block of names that an iterator such as `loop` or `map` gives its items, and the type after `define`. Basic kept every name.
- Rosetta reads the solution's syntax tree, so comments, spaces, line breaks and commas make no difference.
- Each string and number is written as its value, so `{ab}` and `"ab"`, and `0x1F` and `31`, are the same. `1` and `1.0` stay apart, and so do a character such as `'a'` and a string such as `"a"`.
- Brackets around a single value make no difference, so `(x) = 1` and `x = 1` are the same.
- Rosetta drops `import` lines as imports.
- A solution with a syntax error still gets Basic's representation, with Arturo's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Arturo solution again.

## Spellings that share a representation

Arturo's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `{ab}` → `"ab"`, for a string in braces on one line.
- An escape in a string: `"a\tb"` → a string with a tab in it.
- Number spelling: `0x1F` → `31`, `0b101` → `5`, `0o17` → `15`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Commas, which Arturo's parser skips: `[1, 2]` → `[1 2]`.
- Brackets around a single value: `(x) = 1` → `x = 1`.

## Analysis

This service doesn't make Arturo analyses yet, and Arturo has no old analyzer to compare with.

## Snippet

Arturo's snippet now works on the grammar's tree. It removes the comments, as it did before. A file that doesn't parse still gets the snippet made from its lines.
