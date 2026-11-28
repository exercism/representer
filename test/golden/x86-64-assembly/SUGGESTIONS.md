# Suggestions for x86-64 assembly

[`transition.md`](../../../lib/inspector/languages/x8664_assembly/transition.md) says how Inspector treats x86-64 assembly differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to x86-64 assembly's own behaviour needs the maintainers to decide it.
The counts come from the 298 golden solution files, with their comments removed.

## Spellings that NASM reads as the same

1. **Write each conditional jump, `set` and `cmov` with one of its names.** Many conditions have two or three names for the same instruction, so `je` and `jz` assemble to the same bytes, and so do `jne` and `jnz`, `jae`, `jnb` and `jnc`, `jb`, `jc` and `jnae`, and `sete` and `setz`. A mentor might still prefer the name that matches the comparison before it. 106 golden solutions use `je` and 76 use `jz`, and 44 use `jne` and 58 use `jnz`.
2. **Write a character constant as its value.** NASM reads `'a'` in an instruction as the number 97, so `cmp al, 'a'` and `cmp al, 97` are the same instruction. A mentor might comment on the plain number, so the two stay apart. 48 golden solutions use a character constant in an instruction.
3. **Write each run of strings and numbers in a `db` as one list of bytes.** `db 'hi', 0` and `db 'h', 'i', 0` store the same bytes. No golden solution splits a string this way.
4. **Read the escapes in a backquoted string.** NASM reads `` `\n` `` as a line break, so `` db `hi\n` `` and `db 'hi', 10` store the same bytes. Inspector keeps each escape as it is written. No golden solution uses an escape in a backquoted string.
5. **Read a mnemonic as a macro in any case if the macro was defined with `%imacro`.** The grammar reads `%imacro` as `%macro`, so Inspector only writes a use as a call if its case matches the definition. No golden solution uses `%imacro`.

## Equivalences for the maintainers to decide

6. **Write `xor eax, eax` and `mov eax, 0` the same way.** Both set the register to zero, but `xor` also changes the flags. 155 golden solutions `xor` a register with itself, and 48 `mov` 0 into a register.
7. **Write `test eax, eax` and `cmp eax, 0` the same way.** Both set the flags that the jumps after them read for a comparison with zero. 79 golden solutions `test` a register with itself, and 55 `cmp` a register with 0.
8. **Sort the parts of a memory operand.** `[rbx + rax*8]` and `[rax*8 + rbx]` give the same address.
9. **Drop the `%ifidn __OUTPUT_FORMAT__, elf64` block at the end of a file.** The exercise stubs include it, and it only marks the stack as not executable. 251 golden solutions have it, so a solution without it stays apart from one with it.
10. **Drop `default rel`, and the `rel` inside a memory operand.** Both make an address relative to `rip`, which changes the bytes but not what the code does on the test machine. 71 golden solutions use `default rel`, and 34 use `[rel ...]`.
11. **Drop a size keyword where a register already gives the size.** `mov byte [rdi], al` and `mov [rdi], al` assemble to the same instruction, because `al` is one byte. 80 golden solutions write `byte [...]` somewhere, though not every use is redundant.

## Names

12. **Rename a reference to a struc field written with the struc's name.** NASM reads `item_list.size` as the field `.size` of the struc `item_list`. Inspector renames `item_list` and `.size` where they are defined, but keeps `item_list.size` as it is written, because it is one name in the tree. This can only keep two solutions apart, never merge them. 4 golden solutions use such a reference.
13. **Rename a defined name inside a preprocessor argument.** `%ifdef SIZE` keeps `SIZE` as it is written, because the grammar reads the argument as text. This can only keep two solutions apart. 1 golden solution uses `%ifndef` with a name it defines.
