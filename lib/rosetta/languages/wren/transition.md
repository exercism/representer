# Wren's transition

This file says how the Wren outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Wren representer (`exercism/wren-representer`), which parsed the solution with the Lezer Wren grammar, replaced the names of classes, methods and variables with placeholders, and wrote each token with spaces between them.
It differs from the old representer in the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and in these ways:

- **Names.** The old representer kept the names of Wren's core classes (such as `List`, `Num` and `Random`) and the method name `new`, and kept the name of a method called after a dot (`board.size`). Rosetta renames every name the solution defines, wherever it appears, including a method called `new` or `toString`, and keeps every other name.
- **Strings.** The old representer wrote each string as it was written. Rosetta writes each string as its value, so `"""a"""` and `"a"` are the same, and so are `"A"` and `"A"`. A string with interpolations keeps them, with the text between them as values. Only the common escapes are read (`\n`, `\r`, `\t`, `\0`, `\a`, `\b`, `\e`, `\f`, `\v`, `\\`, `\"`, `\%`, `\uHHHH` and `\UHHHHHHHH`), so `"\x41"` and `"A"` stay apart.
- **Numbers.** The old representer wrote each number as it was written. Rosetta writes each number as its value. Every Wren number is a double, so `1.0` and `1` are the same, and so are `0x1F` and `31`.
- **Brackets and braces.** The old representer kept every bracket. Rosetta drops brackets that only group, so `(a + b)` is `a + b`, and puts braces around the body of each `if`, `else`, `while` and `for`, so `if (a) b()` is `if (a) { b() }`.
- **Maps.** Rosetta and the old representer both sort the entries of a map literal. The old representer sorted them by the text of each key. Rosetta sorts them by their code, with the renamed names left out.

## Spellings that share a representation

Wren's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- A raw string and its plain spelling: `"""you"""` → `"you"`, and `"""a\n"""` → `"a\\n"`.
- An escape in a string and the character it stands for: `"\u0041"` → `"A"`, and `"a\nb"` → the string with a real line break.
- Number spelling: `0x1F` → `31`, `1.50` → `1.5`, `1e3` → `1000` and `1.0` → `1`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`.
- Braces around the body of an `if`, `else`, `while` or `for`: `if (a) return 1` → `if (a) { return 1 }`, and `else if (c) return 2` → `else { if (c) { return 2 } }`.

## Analysis

This service doesn't make Wren analyses yet, and Wren has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
