# Suggestions for ARM64 assembly

[`transition.md`](../../../lib/inspector/languages/arm64_assembly/transition.md) says how Inspector treats ARM64 assembly differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to ARM64 assembly's own behaviour needs the maintainers to decide it.
The counts come from the 111 golden solution files, with their comments removed.

## Spellings that the assembler reads as the same

1. **Write `fp` as `x29` and `lr` as `x30`.** The assembler reads each pair as the same register, so `stp fp, lr, [sp, #-16]!` and `stp x29, x30, [sp, #-16]!` assemble to the same instruction. A mentor might still prefer one spelling. 21 golden solutions use `fp` or `lr`, and 9 use `x29` or `x30`.
2. **Write the condition `hs` as `cs` and `lo` as `cc`.** Each pair is one condition with two names, so `b.lo` and `b.cc` are the same branch. 12 golden solutions use `hs` or `lo`, and none uses `cs` or `cc`.
3. **Write `.quad`, `.8byte` and `.xword` as `.dword`.** On AArch64 each one stores 8-byte values, so `.quad 1` and `.dword 1` store the same data. 11 golden solutions use `.dword`, 4 use `.quad` and 2 use `.8byte`.
4. **Write `.string` as `.asciz`.** Both store a string followed by a zero byte. 21 golden solutions use `.string`, and 4 use `.asciz`.
5. **Write `.align n` as `.p2align n`.** On AArch64, `.align 3` aligns to 8 bytes, as `.p2align 3` does. `.balign 8` gives the same result, but takes the number of bytes. 4 golden solutions use `.align`, and 4 use `.balign`.
6. **Read the other escapes in a string.** The assembler reads `\0`, `\r`, `\b`, `\f`, octal escapes such as `\101` and hex escapes such as `\x41` as the characters they stand for. Inspector reads only `\n`, `\t`, `\\` and `\"`, and keeps every other escape as it is written. No golden solution uses one of the other escapes.
7. **Write a character as its value.** The assembler reads `'A'` as the number 65, so `mov w0, #'A'` and `mov w0, #65` are the same instruction. A mentor might comment on the plain number, so the two stay apart.

## Equivalences for the maintainers to decide

8. **Write `mov x0, #0` and `mov x0, xzr` the same way.** Both set the register to zero. 42 golden solutions move `#0` into a register, and 23 move `xzr` or `wzr`.
9. **Write `cmp x0, #0` followed by `b.eq` or `b.ne` as `cbz` or `cbnz`.** Both branch on whether the register is zero, but the `cmp` also sets the flags, so this is only safe where nothing reads them afterwards. 5 golden solutions compare with zero before such a branch, and 90 use `cbz` or `cbnz`.
10. **Write each use of a register alias as its register.** `count .req x0` followed by `add count, count, 1` and `add x0, x0, 1` give the same instruction, but the first is renamed and the second keeps `x0`, so the two stay apart. A mentor might comment on the aliases, which make the code easier to read. 13 golden solutions define aliases with `.req`.
11. **Drop the `.text` directive at the top of a file.** Code goes in the text section by default, so a file that starts with `.text` and one without it assemble to the same code. All 111 golden solutions have a `.text` line.

## Names

12. **Rename a macro's argument inside a string in the macro's body.** Inside a macro, the assembler replaces `\s` in a string with the argument `s`. Inspector reads it as an escape, so the parameter is renamed but its use in the string isn't. A parameter with a name that starts with `n` or `t`, such as `\name`, is read as the escape `\n` followed by `ame`. This can only keep two solutions apart, never merge them. 1 golden solution uses a macro argument in a string.
13. **Read a macro's name in any case.** The assembler finds a macro by its name in any case, so a macro defined as `LOAD` can be used as `load`. Inspector only writes a use as a call if its case matches the definition. No golden solution uses a macro in another case.
