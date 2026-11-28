# COBOL's transition

This file says how the COBOL outputs of this service differ from the tools they replace, and why.

## Representation

COBOL had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-cobol instead, and writes the tree that a COBOL compiler's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: the program, its data items and condition names, constants, index names, files, paragraphs, sections and the parameters of the PROCEDURE DIVISION. Names that the solution doesn't define keep their names, such as `FUNCTION TRIM` or `UPPER-CASE`.
- **Case.** COBOL ignores the case of names, keywords and pictures, so Inspector writes them all one way. `Move Ws-Total To WS-RESULT` and `MOVE WS-TOTAL TO WS-RESULT` are the same. Strings keep their case.
- **Layout.** Basic kept line breaks and indentation. Inspector drops comments and layout. In COBOL's fixed format, the first six columns of a line are the sequence area, a `*` or `/` in the seventh column makes the line a comment, and the columns after the 72nd are ignored on a line with a sequence number. None of these can change whether a solution works, so Inspector drops them, as the compiler does.
- **Comment entries.** COBOL reads the paragraphs after PROGRAM-ID (`AUTHOR`, `INSTALLATION`, `DATE-WRITTEN`, `DATE-COMPILED` and `SECURITY`) as comments, so Inspector drops them.
- **Keywords.** COBOL has several spellings of many keywords, and lets a statement leave out some words. Inspector gives each keyword one spelling, and drops `IS`, `ARE` and `THEN`, which never change a statement. It keeps every other word, such as the `LENGTH OF` in `MOVE LENGTH OF X TO Y` or the `TRUE` in `SET X TO TRUE`.
- **Full stops.** Inspector keeps the full stop that ends each sentence in the PROCEDURE DIVISION, because it ends every open `IF`. It drops the other full stops.
- **Brackets.** Inspector keeps the brackets in arithmetic and in conditions. The grammar reads `AND` and `OR` with the same precedence, so the brackets are the only way to tell `(A OR B) AND C` from `A OR B AND C`.
- **Imports.** `REPOSITORY. FUNCTION ALL INTRINSIC.` is dropped, as an import.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'it''s'` and `"it's"` are the same. A string continued onto another line keeps its text.
- **Numbers and pictures.** Basic kept each number as written. Inspector writes each number and level number as its value, so `007` and `7` are the same, and so are `01` and `1`, and `1.50` and `1.5`. An integer and a decimal stay apart. Each picture is written with the count of each run of a symbol, so `PIC 9999` and `PIC 9(4)` are the same.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with COBOL's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

COBOL's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- The case of keywords, names and pictures: `move Ws-X to ws-y` → `MOVE WS-X TO WS-Y`, and `PIC x(3)` → `PIC X(3)`.
- Quote style: `'it''s'` → `"it's"`.
- Number spelling: `007` → `7`, `+5` → `5`, `1.50` → `1.5`, and the level number `01` → `1`.
- Picture spelling: `PIC 9999` → `PIC 9(4)`, and `PIC X(2)X` → `PIC X(3)`.
- Comparisons: `IS GREATER THAN` → `>`, `NOT LESS THAN` → `>=`, `EQUAL`, `EQUALS` and `IS EQUAL TO` → `=`, and `NOT EQUAL TO` and `NOT =` → `<>`.
- Synonyms: `THROUGH` → `THRU`, `PICTURE` → `PIC`, `ZEROS` and `ZEROES` → `ZERO`, `SPACES` → `SPACE`, `HIGH-VALUES` → `HIGH-VALUE`, `LOW-VALUES` → `LOW-VALUE` and `QUOTES` → `QUOTE`, and `COMPUTE X EQUAL 1` → `COMPUTE X = 1`.
- Optional words: `IF X IS NUMERIC THEN` → `IF X NUMERIC`, `USAGE IS COMP` → `COMP`, and `IDENTIFICATION DIVISION. PROGRAM-ID. P.` → `PROGRAM-ID. P.`, which GnuCOBOL reads the same.
- Separators: a comma or semicolon between words is a space, so `MOVE 0 TO A, B` → `MOVE 0 TO A B`.
- Fixed-format columns: the sequence area, comment lines, and the columns after the 72nd on a line with a sequence number.
- The comment entries after PROGRAM-ID: `AUTHOR. Ada.` → nothing.
- Full stops outside the PROCEDURE DIVISION's sentences: `01 X PIC 9.` → `01 X PIC 9`.

## Analysis

This service doesn't make COBOL analyses yet, and COBOL had no analyzer, so there is nothing to compare.

## Snippet

The snippet works on lines, with the same rules as Basic's snippet for the track, because the grammar leaves the comment lines out of its tree.
It removes every comment, so it gives every solution the same snippet as before, and its version stays 1.
