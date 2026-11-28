# Fortran's transition

This file says how the Fortran outputs of this service differ from the tools they replace, and why.

## Representation

Fortran had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-fortran instead, and writes the tree that a Fortran compiler's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: programs, modules, interfaces, functions, subroutines, their parameters and results, variables and constants, derived types and their components, type-bound procedures, the names given by `associate`, construct labels, and the variables assigned to without a declaration.
- **Case.** Fortran ignores the case of names and keywords, so Inspector writes them all in lower case. `MOD(Year, 4)` and `mod(year, 4)` are the same. Strings keep their case.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, `&` continuations, semicolons, `::` and brackets that only group, so `(a * b) / c` and `a * b / c` are the same. It also drops the end statements, so `end function f`, `end function` and `end` are the same, and so are `endif` and `end if`.
- **Spellings Fortran reads as one.** Fortran's parser reads `.eq.` and `==` as the same operator, and the same for `.ne.`, `.lt.`, `.le.`, `.gt.` and `.ge.`. It also reads `(/ 1, 2 /)` and `[1, 2]` as the same array, and a keyword with or without its space (`else if` and `elseif`, `double precision` and `doubleprecision`) as the same keyword. Inspector gives each pair the same representation.
- **Imports.** The `use` statements are dropped, as imports.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'it''s'` and `"it's"` are the same.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `007` and `7` are the same, and so are `1e3` and `1000.0`, and `1.5D0` and `1.50d0`. An integer, a default real and a double precision real stay apart, and a kind such as the `dp` in `2.0_dp` stays.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Fortran's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Fortran's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- The case of keywords and names: `IF (A > B) THEN` → `if (a > b) then`, and `MOD(Year, 4)` → `mod(year, 4)`.
- Quote style: `'it''s'` → `"it's"`, and `"say ""hi"""` → `'say "hi"'`.
- Number spelling: `007` → `7`, `1e3` → `1000.0` and `1.5D0` → `1.50d0`.
- Relational operators: `a .eq. b` → `a == b`, and the same for `.ne.`, `.lt.`, `.le.`, `.gt.` and `.ge.`.
- Array brackets: `(/ 1, 2 /)` → `[1, 2]`.
- A keyword with or without its space: `else if` → `elseif`, `go to` → `goto`, `double precision` → `doubleprecision`, and `intent(in out)` → `intent(inout)`.
- End statements: `end function f` → `end function` → `end`, and `end if` → `endif`.
- Brackets that only group: `(a * b) / c` → `a * b / c`.
- The `::` of a declaration: `integer :: f` → `integer f`.
- A `;` after a statement, and a `&` line continuation: `r = a > b;` → `r = a > b`.

## Analysis

This service doesn't make Fortran analyses yet, and Fortran had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `use` statements at the top of the file, up to the first other statement.
Its version is now 2.
