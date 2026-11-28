# x86-64 assembly's transition

This file says how the x86-64 assembly outputs of this service differ from the tools they replace, and why.

## Representation

x86-64 assembly had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-x86-64-assembly instead, and writes the tree that NASM reads.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: labels (local labels such as `.loop` and macro labels such as `%%skip` too), the names of data and of constants defined with `equ`, names defined with `%define` or `%assign` and the parameters of a `%define`, macros, strucs, and the fields inside a struc. A reference to a field with its struc's name, such as `point.x`, keeps its text. Registers, instructions and names from outside the file, such as `extern printf`, keep their names.
- **Layout.** Basic kept line breaks and the spaces between tokens. Inspector drops comments and layout, including the layout inside a preprocessor argument such as `%ifidn __OUTPUT_FORMAT__, elf64`.
- **Imports.** Inspector drops each `%include`, because a solution that passes its tests has already loaded everything it needs.
- **Spellings.** NASM reads some pairs of spellings as the same program, and Inspector gives each pair one form. The list is below.
- **Strings and numbers.** A string is written as its value, so `'hi'` and `"hi"` are the same. A string in backquotes keeps each of its escapes as it is written. A number is written as its value, so `0x1F`, `1Fh`, `$1F` and `31` are the same. A character constant stays a string, so `'A'` and `65` stay apart.
- **Macro calls.** The grammar reads a use of a macro as an instruction. Inspector writes it as a call to the macro, so the macro's name is renamed with its definition.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with x86-64 assembly's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

NASM reads each of these pairs as the same program, so Inspector gives them the same representation:

- A label before a data or constant definition, with or without its colon, and on the same line or the line before: `msg: db "hi"` → `msg db "hi"`, and `SIZE: equ 8` → `SIZE equ 8`.
- The two names of the section directive: `segment .data` → `section .data`.
- The case of mnemonics, registers, sizes, prefixes and directives: `MOV RAX, QWORD [RBX]` → `mov rax, qword [rbx]`, and `SECTION .text` → `section .text`.
- Single and double quotes: `db 'hi', 0` → `db "hi", 0`.
- Number spelling: `0x1F`, `0h1F`, `$1F` and `1Fh` → `31`, `0b101` and `101b` → `5`, `0o17` and `17q` → `15`, and `1_000` → `1000`.
- Brackets that only group: `(1 + 2) * 3` → `1 + 2 * 3`.
- A trailing comma after the last operand: `pop rax,` → `pop rax`.
- The spaces in a preprocessor argument: `%ifidn  __OUTPUT_FORMAT__, elf64` → `%ifidn __OUTPUT_FORMAT__,elf64`.

## Analysis

This service doesn't make x86-64 assembly analyses yet, and x86-64 assembly had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track, and removed the comments found by Rouge's NASM lexer.
It now reads the solution's syntax tree, so it removes every comment that tree-sitter finds.
If a file doesn't parse, it still removes the comments found by Rouge's NASM lexer.
Its version is now 2.
