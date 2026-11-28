# ARM64 assembly's transition

This file says how the ARM64 assembly outputs of this service differ from the tools they replace, and why.

## Representation

ARM64 assembly had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-arm64-assembly instead, and writes the tree that the GNU assembler reads.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: labels (numbered local labels such as `1:` too, with their references such as `1b` and `2f`), constants defined with `.equ`, `.set`, `.eqv`, `.equiv` or `=`, register aliases defined with `.req`, macros, and the parameters of macros. Registers and instructions keep their names.
- **Layout.** Basic kept line breaks and the spaces between tokens. Inspector drops comments (`//`, `/* */` and `#` at the start of a statement), layout, and the `;` between statements on one line.
- **Spellings.** The assembler reads some pairs of spellings as the same program, and Inspector gives each pair one form. The list is below.
- **Strings and numbers.** A string is written as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. A number is written as its value, so `0x1F` and `31` are the same, and so are `010` and `8`, because the assembler reads a number that starts with `0` as octal. A character keeps its quotes, so `'A'` and `65` stay apart.
- **Macro calls.** The grammar reads a use of a macro as an instruction. Inspector writes it as a call to the macro, so the macro's name is renamed with its definition.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with ARM64 assembly's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

The GNU assembler reads each of these pairs as the same program, so Inspector gives them the same representation:

- An immediate with or without its `#`: `mov x0, #1` → `mov x0, 1`, and `ldr x1, [x0, #8]` → `ldr x1, [x0, 8]`.
- The three ways to define a constant: `.set SIZE, 8` → `.equ SIZE, 8`, and `SIZE = 8` → `.equ SIZE, 8`.
- The two spellings of the same directive: `.global main` → `.globl main`.
- The case of mnemonics, registers, shifts, extends, arrangements and conditions: `MOV X0, X1, LSL #2` → `mov x0, x1, lsl #2`, `B.EQ done` → `b.eq done`, and `v0.16B` → `v0.16b`.
- A character with or without its closing quote: `'a` → `'a'`.
- Number spelling: `0x1F` → `31`, `0b101` → `5` and `010` → `8`.
- An escape and the character it stands for: `"a\tb"` → the string with a real tab.
- Brackets that only group: `#(1 << 4)` → `#1 << 4`.
- A `;` and a line break between statements: `mov x0, #1; ret` → the two statements on two lines.

## Analysis

This service doesn't make ARM64 assembly analyses yet, and ARM64 assembly had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track, and kept every comment, because Rouge has no ARM64 assembly lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is.
If a file doesn't parse, it removes the lines and line ends that start with `//` and the blocks between `/*` and `*/`.
Its version is now 2.
