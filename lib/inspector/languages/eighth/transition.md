# 8th's transition

This file says how the 8th outputs of this service differ from the tools they replace, and why.

## Representation

8th had no representer of its own, so the track used Basic, which splits the code at whitespace and keeps every word as it is written, including comments and line breaks.
The representation now parses the solution with tree-sitter-8th and writes the tree that 8th's own reader would give.
It follows the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes.
For 8th, these are the changes:

- **Names.** Basic kept every name. Every word defined with `:`, `constant` or `var` now gets a placeholder wherever it appears, including after `'`. A word the solution doesn't define, such as `s:len`, keeps its name.
- **Comments.** Inspector drops every comment: `\ text`, `-- text`, `SED: text` and `(* text *)`. So a stack-effect comment, such as `\ n -- ?` after a word's name, makes no difference.
- **Layout.** Line breaks and the spaces between words make no difference. The brackets of a quotation, an array or a map, the `:` and `;` of a definition, and the `if` and `then` of a conditional are left out, because the tree already shows them. `!if`, `else`, `;then`, the word that ends a loop and the `G:` forms stay.
- **Strings and numbers.** Each string is written as its value, so `"a\nb"` and a string with a line break are the same. Each number is written as its value: `0xff`, `$ff` and `255` are the same, and `1.50` and `1.5` are the same. 8th keeps integers and decimals apart, so `1.0` and `1` stay apart. A number with a multiplier, such as `1k`, keeps its text.
- **Maps.** A bare key in a map is written as a string, so `{ a: 1 }` and `{ "a": 1 }` are the same.
- **Imports.** Inspector drops each `needs`, such as `needs types/set`.
- **Errors.** A solution with a syntax error still gets Basic's representation, with 8th's version. All 166 golden solutions parse.

The representation's version is 6, one above Basic's version 5, so the website will represent every 8th solution again.

## Spellings that share a representation

8th's reader reads each of these pairs as the same program, so Inspector gives them the same representation:

- A definition that starts with `;:` and one that starts with `:` after a `;`: `: f 1 ;: g 2 ;` → `: f 1 ; : g 2 ;`.
- A comma between the items of an array or a map, and a space: `[1, 2]` → `[1 2]`.
- A bare key in a map and the same key as a string: `{ a: 1 }` → `{ "a": 1 }`.
- An escape in a string and the character it stands for: `"a\tb"` → a string with a tab.
- Number spelling: `0xff` → `255`, `$ff` → `255`, `1.50` → `1.5` and `1e3` → `1000.0`.

## Analysis

This service doesn't make 8th analyses yet, and 8th had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to keep every line as it was written, because no lexer knew 8th's comments.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `needs` lines at the top of the file.
A file that doesn't parse keeps its comments.
Its version is now 2.
