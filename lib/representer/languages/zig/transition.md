# Zig's transition

This file says how the Zig outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Zig representer (`exercism/zig-representer`), which joined the solution files and removed blank lines and trailing whitespace. It never changed a name, and it kept the code as it was written.
It differs from the old representer in the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and in these ways:

- **Syntax errors.** A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer represented any text.
- **Comments.** Comments and doc comments are dropped. The old representer kept them.
- **Imports.** A declaration such as `const std = @import("std");` or `const print = @import("std").debug.print;` is dropped, wherever it is. The old representer kept it.
- **Layout.** The representation is built from the syntax tree, so spaces, line breaks, trailing commas and brackets that only group make no difference. The old representer kept every space within a line and every bracket.
- **Names.** Every name the solution defines is renamed, wherever it appears: functions, constants, variables, parameters, the variables of payloads such as `|item|`, labels, struct fields, enum values and error names. `_` keeps its name, because it discards a value. The old representer kept every name.
- **Strings.** Each string is written as its value, so `"a\x0Ab"` and `"a\nb"` are the same, and so are `"\u{41}"` and `"A"`. A byte escape such as `"\xff"` stays as it is written. Characters and multiline strings keep their text.
- **Numbers.** Each number is written as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, and `1.50` and `1.5`.

## Spellings that share a representation

Zig's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- An escape in a string and the character it stands for: `"a\x0Ab"` → `"a\nb"`, `"\x41"` → `"A"`, and `"\u{41}"` → `"A"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A trailing comma after the last item: `g(a, b,)` → `g(a, b)`, `.{ 1, 2, }` → `.{ 1, 2 }`, `f(a: u32, b: u32,)` → `f(a: u32, b: u32)`, and `struct { x: u32, y: u32, }` → `struct { x: u32, y: u32 }`.

## Analysis

This service doesn't make Zig analyses yet, and Zig has no old analyzer to compare with.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and the `const std = @import` line by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the import of the standard library at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
