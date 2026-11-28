# Suggestions for COBOL

[`transition.md`](../../../lib/inspector/languages/cobol/transition.md) says how Inspector treats COBOL differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to COBOL's own behaviour needs a human to decide it.
The counts come from a text search of the 193 golden solutions, so they are approximate.

## Spellings that are apart today

1. **Write an `END-IF` before a full stop as nothing.** A full stop ends every open `IF`, so `IF A MOVE 1 TO X END-IF.` and `IF A MOVE 1 TO X.` are the same program. Today they stay apart, because a mentor might comment on the explicit scope terminator. 62 golden solutions end an `IF` with `END-IF.`. The same goes for `END-PERFORM.`, `END-EVALUATE.` and the other scope terminators.
2. **Drop an empty ENVIRONMENT DIVISION or CONFIGURATION SECTION header.** `ENVIRONMENT DIVISION.` with nothing after it makes no difference to the program, and the compiler reads the program the same without it. 112 golden solutions have an ENVIRONMENT DIVISION, and 109 of them are empty, or hold only the REPOSITORY paragraph that Inspector drops.
3. **Write `COMP` and `COMPUTATIONAL` as one keyword, and the same for `COMP-3` and `PACKED-DECIMAL`.** GnuCOBOL reads each pair as the same usage. 3 golden solutions use `COMP`.
4. **Write a function call that follows `REPOSITORY. FUNCTION ALL INTRINSIC.` with its `FUNCTION` keyword.** With the REPOSITORY paragraph, `TRIM(X)` calls the same function as `FUNCTION TRIM(X)`, but the grammar reads it as a table item, so the two stay apart. 22 golden solutions have the paragraph.
5. **Unwrap brackets that only group in arithmetic.** The grammar gives an arithmetic expression as a flat list of operands and operators, so Inspector keeps every bracket, and `(A * B) + C` stays apart from `A * B + C`. Building the tree with COBOL's precedence would let Inspector drop the brackets that only group. 48 golden solutions use brackets in a COMPUTE. Conditions have the same gap: the grammar reads `AND` and `OR` with the same precedence, where COBOL reads `AND` first.
6. **Drop the words that the grammar leaves out of its tree when they never change the statement.** Inspector keeps every such word in the statements that need some of them, such as the `MOVE` and `TO` of `MOVE X TO Y`. Words such as `BY` in `DELIMITED BY` or `ON` in `DEPENDING ON` are fixed, so dropping them would only make the representation shorter, and change no groups.

## Names

7. **Keep a program's name apart from a paragraph with the same name.** Inspector renames by text, so `PROGRAM-ID. LEAP.` and the paragraph `LEAP.` get the same placeholder. The renaming is consistent, so it makes no difference to the groups. Most golden solutions name their first paragraph after the program.

## The grammar

8. **Nest the statements inside `IF`, `EVALUATE` and inline `PERFORM`.** The grammar gives each `IF`, `ELSE`, `WHEN` and `END-IF` as a statement of its own in one flat list. The tree keeps the order and the scope terminators, so different programs stay apart, but a nested tree would make rules about these statements much simpler to write.
9. **Parse `REPOSITORY. FUNCTION TRIM REVERSE INTRINSIC.`** The grammar reads only `FUNCTION ALL INTRINSIC`, so a solution that names its functions gets Basic's representation. No golden solution names its functions.

## Snippet

10. **Skip the IDENTIFICATION DIVISION at the top of the file.** Every solution starts with the same few header lines, so the card could start at the DATA DIVISION or the PROCEDURE DIVISION. The 15 lines of the card often show only headers and data items today.
