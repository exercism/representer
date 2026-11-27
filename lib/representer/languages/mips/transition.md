# MIPS's transition

This file says how the MIPS outputs of this service differ from the tools they replace, and why.

## Representation

MIPS had no representer of its own, so it used Basic, which writes a solution's tokens line by line and renames nothing.
The representation now parses the solution with tree-sitter-mips and writes the tree that the assembler reads.
It follows the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes.
For MIPS, these are the changes:

- Every name the solution defines gets a placeholder: labels, `.eqv` constants, macros and the parameters of macros. Basic kept every name. Registers and instructions keep their names.
- Comments and layout make no difference. Basic kept line breaks and the spaces between tokens, so `addi $t0, $zero, 400` and `addi $t0,$zero,400` were apart.
- Operands split by spaces are the same as operands split by commas, because the assembler reads them the same.
- A call to a macro is the same with or without a space before its brackets, so `store ('A')` and `store('A')` are the same, and so are `clear` and `clear()`.
- A number is written as its value, so `0x1F` and `31` are the same, and so are `010` and `8`, because the assembler reads a number that starts with `0` as octal.
- A string is written as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. A character keeps its quotes, so `'A'` and `65` stay apart.

The representation starts at version 6, one above Basic's version 5.
If a solution doesn't parse, it still gets Basic's representation, now with version 6.

## Analysis

This service doesn't make MIPS analyses yet, and MIPS had no analyzer, so there is nothing to compare.

## Snippet

The snippet works on lines, as before, and is unchanged.
It removes every comment and the `.data`, `.text` and `.globl` lines.
