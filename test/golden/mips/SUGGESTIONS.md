# Suggestions for MIPS

[`transition.md`](../../../lib/inspector/languages/mips/transition.md) says how Inspector treats MIPS differently from Basic, which MIPS used before.
These are changes that could improve it.
None of them is made, because a change to MIPS's own behaviour needs the maintainers to decide it.

## Spellings that the assembler reads as the same

1. **Write each register by its name.** The assembler reads `$0` as `$zero` and `$8` as `$t0`. The golden solutions use `$0` 134 times. Today `add $t0, $t1, $0` and `add $t0, $t1, $zero` stay apart. Mentors may comment on numbered registers, so this is a judgement call.
2. **Write an address without an offset with the offset `0`.** The assembler reads `lw $t1, ($t0)` as `lw $t1, 0($t0)`. The golden solutions use the short form 86 times.
3. **Write a character as its value.** The assembler reads `li $t0, 'A'` as `li $t0, 65`. Mentors would usually suggest the character, so the two may deserve to stay apart.
4. **Drop a `.text` at the start of the code.** The assembler starts in the text segment, so a file that starts with `.text` and one that doesn't assemble to the same program. 31 golden solutions have a `.text`.

## Equivalences for the maintainers to decide

5. **Treat pseudo-instructions as the instructions they stand for.** `li $t0, 5` and `addi $t0, $zero, 5` (or `ori $t0, $zero, 5`) load the same value, and `move $t0, $t1` and `add $t0, $t1, $zero` copy the same register. Mentors often comment on the choice, so this is a judgement call.
6. **Replace each `.eqv` constant with its value.** The assembler replaces the name with its text before it assembles the code, so `.eqv LIMIT 10` with `li $t0, LIMIT` and `li $t0, 10` give the same program. Mentors would comment on magic numbers, so the two may deserve to stay apart.
7. **Reorder the data and code sections.** The assembler places each `.data` and `.text` section in its own segment, so a solution that puts its `.data` block before its code and one that puts it after give the same program. A Reorder stage could put the data sections first.
8. **Drop the `.globl` lines, or sort them.** Every solution exports the labels used by the tests, so `.globl` lines in another place or order make no difference.

## The grammar

9. **Read a comma after an instruction's name.** The pinned grammar rejects `addi, $t0, $t0, 1`, which the assembler accepts, so one golden solution (luhn) gets Basic's representation.
