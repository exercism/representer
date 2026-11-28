# Uiua's transition

This file says how the Uiua outputs of this service differ from the tools they replace, and why.

## Representation

Uiua had no representer of its own, so the track used Basic, which drops comments and the spaces between tokens and keeps everything else as it is written, including line breaks.
The representation now parses the solution with tree-sitter-uiua and writes the tree that Uiua's own parser would read.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For Uiua, these are the changes:

- **Names.** Basic kept every name. Every name that a binding, a module or a data definition defines (including the fields of a data definition) now gets a placeholder wherever it appears, including in a module access such as `Character~Ability`. A name brought in by an import keeps its name.
- **Primitives.** Uiua's formatter turns the name of a primitive into its glyph, and Uiua reads the two as the same program. So Rosetta writes each primitive as its glyph: `reverse`, `rev` and `⇌` are the same, and so are `*` and `×`, `%` and `÷`, and `` ` `` and `¯`. A primitive can be written by its name, by a short name such as `ne` for `≠`, or by the start of its name, if that start is at least three letters long and no other primitive's name starts the same way. A primitive with no glyph, such as `datetime`, keeps its name.
- **Subscripts.** A subscript is written in subscript digits, so `+__2` and `+₂` are the same.
- **Bindings.** `=` at the start of a binding is the same as `←`, and `=~` and `←~` are the same as `↚`. A private binding (`↚`) stays apart from a public one (`←`).
- **Layout.** Comments, line breaks and the spaces between tokens make no difference.
- **Strings and numbers.** Each string, format string and character is written as its value, so `"a\sb"` and `"a b"` are the same, and `@\s` and `@ ` are the same. Each number is written as its value, because Uiua stores every number the same way: `1e9` and `1000000000` are the same, and so are `1.0` and `1`, `1.50` and `1.5`, and `` `3 `` and `¯3`. A fraction such as `1/2` keeps its text.
- **Imports.** Rosetta drops each import of another file, such as `Lib ~ "lib.ua"`.
- **Errors.** A solution with a syntax error still gets Basic's representation, with Uiua's version. All 217 golden solutions parse.

The representation's version is 6, one above Basic's version 5, so the website will represent every Uiua solution again.

## Spellings that share a representation

Uiua's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- A primitive's name and its glyph: `reverse` → `⇌`, `under un datetime` → `⍜°datetime` and `pi` → `π`.
- A short name of a primitive: `ne` → `≠`, `flat` → `♭` and `fst` → `⊢`.
- The start of a primitive's name: `rev` → `⇌` and `abs` → `⌵`.
- An ASCII spelling of a primitive: `*` → `×`, `%` → `÷` and `` ` `` → `¯`.
- A subscript written with `__`: `+__2` → `+₂` and `+__¯1` → `+₋₁`.
- The ASCII binding arrows: `F = +1` → `F ← +1`, and `F ←~ +1` and `F =~ +1` → `F ↚ +1`.
- An escape in a string or a character and the character it stands for: `"a\sb"` → `"a b"`, `@\s` → `@ ` and `"a\tb"` → a string with a tab.
- Number spelling: `1e9` → `1000000000`, `1.0` → `1`, `1.50` → `1.5` and `` `3 `` → `¯3`.

## Analysis

This service doesn't make Uiua analyses yet, and Uiua had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to find the comments by the way their lines start.
It now reads the solution's syntax tree, so it removes every comment wherever it is, including one that follows code without a space.
A file that doesn't parse still loses the comments found by the way their lines start.
Its version is now 2.
