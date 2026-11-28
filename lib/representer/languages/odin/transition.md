# Odin's transition

This file says how the Odin outputs of this service differ from the tools they replace, and why.

## Representation

Odin had no representer of its own, so the track used Basic. Rouge has no Odin lexer, so Basic split the code at whitespace, dropped the `import` lines, and kept everything else as it was written, including the comments, the line breaks and the names.
Odin now has a representation of its own, which reads the solution's syntax tree with BradLewis/tree-sitter-odin and follows the decisions that apply to every language ([README.md](../../../../README.md#how-it-works) describes them).
These things change for Odin:

- **Names.** Basic renamed nothing. The representer renames every name the solution defines: its package, procedures, structs, unions, enums and their values, constants, variables, parameters, named results, struct fields, labels, the variables of `for` loops and type switches, and polymorphic names such as `$T`. `_` keeps its name, because it defines nothing. A name the solution doesn't define, such as `len`, `fmt` or `strings.to_upper`, keeps its name, and so does the alias of an import, such as `str` in `import str "core:strings"`.
- **Layout.** Basic kept the line breaks. The representer ignores all layout, so semicolons, trailing commas and the placing of braces make no difference.
- **Comments.** Basic kept comments. The representer drops `//` and `/* */` comments.
- **Imports.** As before, `import` declarations go.
- **Brackets.** Brackets that only group make no difference, so `return (a + b)` and `if (x > 1)` are the same as the code without them. A single result in brackets, as in `proc() -> (int)`, is the same as `proc() -> int`. The brackets of a type assertion such as `v.(int)` stay.
- **Numbers.** Basic kept each number as written. The representer writes each number as its value, so `0x1F` and `31` are the same, and so are `1_000` and `1000`, and `1.50` and `1.5`. `1` and `1.0` stay apart, because Odin gives them different types.
- **Strings.** Basic kept each string as written. The representer writes each string as its value, with its escapes read, so `` `a` ``, `"a"` and `"\x61"` are the same. An escape for a byte above 127, such as `"\xff"`, stays as it is written. A character such as `'a'` keeps its text.
- **Odin's own equivalences.** Odin's parser puts the statement after a `do` in a block, reads `x if c else y` as the same expression as `c ? x : y`, and reads `-1` as `-` applied to `1`. So `if x do return 1` and `if x { return 1 }` get the same representation, and so do the two ternaries, and `-1` and `- 1`.
- **Errors.** A solution with a syntax error still gets Basic's representation, with Odin's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Odin solution again.

## Spellings that share a representation

Odin's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: `` `you` `` → `"you"`.
- An escape and the character it stands for: `"\x41"` → `"A"`, `"\u0041"` → `"A"` and `"\101"` → `"A"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b101` → `5`, `0o17` → `15`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, and `-> (int)` → `-> int` for a single result.
- A `;` at the end of a statement: `x := 1;` → `x := 1`.
- A trailing comma after the last item: `[]int{1, 2,}` → `[]int{1, 2}`.
- A `do` and braces: `if a > b do return a` → `if a > b { return a }`.
- The two ways to write a ternary: `a if b > 0 else c` → `b > 0 ? a : c`.

## Analysis

This service doesn't make Odin analyses yet, and Odin had no analyzer before.

## Snippet

The snippet used to work on lines, and found comments by the way they start.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the package declaration and the imports at the top of the file, up to the first other statement.
A file that doesn't parse still gets the rules for lines.
The snippet's version is now 2.
