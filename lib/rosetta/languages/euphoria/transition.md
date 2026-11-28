# Euphoria's transition

This file says how the Euphoria outputs of this service differ from the tools they replace, and why.

## Representation

Euphoria had no representer of its own (there is no `exercism/euphoria-representer`), so Euphoria used Basic. Rouge has no Euphoria lexer, so Basic split the code at whitespace and kept everything else as it is written, including comments.
Euphoria now has a representation of its own, which follows the decisions that apply to every language ([docs/how-it-works.md](../../../../docs/how-it-works.md) describes them).
These things change for Euphoria:

- Rosetta renames every name the solution defines, so two solutions that differ only in their names get the same representation. This covers routines, types, parameters, variables, constants, enum members, loop variables and the namespace a file declares. Basic kept every name.
- Rosetta reads the solution's syntax tree, so comments, spaces and line breaks make no difference.
- Each string and number is written as its value, so `` `a\d` `` and `"a\\d"`, and `#1F` and `31`, are the same. `1` and `1.0` stay apart, and so do a character such as `'a'` and a string such as `"a"`.
- Brackets that only group make no difference, and nor does a trailing comma in a sequence or the `$` that may end a list of constants or enum members.
- Rosetta drops `include` lines, with or without `public`, `export` or `global`, as imports.
- A solution with a syntax error still gets Basic's representation, with Euphoria's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Euphoria solution again.

## Spellings that share a representation

Euphoria's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `` `a\d` `` → `"a\\d"`, and `"""ab"""` → `"ab"`, for a raw string on one line.
- An escape in a string: `"a\"b"` → `` `a"b` ``.
- Number spelling: `#1F` → `31`, `0x1F` → `31`, `0b101` → `5`, `0t17` → `15`, `0d9` → `9`, `1_000` → `1000` and `.50` → `0.5`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma in a sequence: `{1, 2,}` → `{1, 2}`.
- The `$` at the end of a list of constants or enum members: `constant A = 1, B = 2, $` → `constant A = 1, B = 2`.
- An include's path in quotes: `include "std/math.e"` → `include std/math.e`.

## Analysis

This service doesn't make Euphoria analyses yet, and Euphoria has no old analyzer to compare with.

## Snippet

Euphoria's snippet now works on the grammar's tree. It removes the comments and skips the `include` lines at the top of the file, as it did before. A file that doesn't parse still gets the snippet made from its lines.
