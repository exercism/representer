# SQLite's transition

This file says how the SQLite outputs of this service differ from the tools they replace, and why.

## Representation

SQLite had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
Inspector parses each solution with tree-sitter instead.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: the tables, views, triggers and indexes that it creates, the columns of its tables, its common table expressions and their columns, and the aliases of columns and tables. The tables and columns of the exercise's schema keep their names.
- **Case.** SQLite reads keywords and names in any case, so Inspector writes both in lower case. `SELECT Upper(Name)` and `select upper(name)` are the same. A double-quoted name keeps its case.
- **Strings.** Basic kept each string as written. Inspector writes each single-quoted string as its value, so `'it''s'` gives the value `it's`. SQLite reads a double-quoted text as a name if a column has that name, and as a string otherwise, so a double-quoted text gets a node of its own and stays apart from both.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `0x1F` and `31` are the same, and so are `1e3` and `1000.0`, and `.50` and `0.5`.
- **Layout.** Brackets that only group, the `;` after the last statement and the `AS` before an alias make no difference.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with SQLite's version.

## Spellings that share a representation

SQLite's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- The case of keywords and names: `SELECT Upper(A)` → `select upper(a)`.
- Backticks around a name: `` `total` `` → `total`.
- Quote style inside a string: `'it''s'` → the value `it's`.
- Number spelling: `0x1F` → `31`, `1e3` → `1000.0`, `.50` → `0.5` and `007` → `7`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A `;` after the last statement: `SELECT 1;` → `SELECT 1`.
- `AS` before an alias: `SELECT a AS b` → `SELECT a b`.
- The spellings of equals and not equals: `a == b` → `a = b`, and `a <> b` → `a != b`.
- `RECURSIVE` after `WITH`: `WITH RECURSIVE a AS (...)` → `WITH a AS (...)`.
- `INNER` and `OUTER` in a join: `INNER JOIN` → `JOIN`, and `LEFT OUTER JOIN` → `LEFT JOIN`.
- `TEMPORARY` and `TEMP`: `CREATE TEMPORARY TABLE` → `CREATE TEMP TABLE`.

## Analysis

This service doesn't make SQLite analyses yet, and SQLite has no old analyzer to compare with.

## Snippet

SQLite's snippet removes the comments that tree-sitter finds. Basic found them with the track's Rouge lexer, which read the `--csv` in a line such as `.import --csv combined.csv` as a comment and cut it, so that one golden snippet changes.
