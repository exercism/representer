# Free Pascal's transition

This file says how the Free Pascal outputs of this service differ from the tools they replace, and why.

## Representation

Free Pascal had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with tree-sitter-pascal instead, and writes the tree that Free Pascal's own parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: units, functions, procedures, methods, constructors and destructors, parameters, variables, constants, labels, types, record and class fields, properties, enumeration values, type parameters, the name an operator gives its result, and the variable in `on e: Exception do`. Names from Free Pascal's libraries, such as `IntToStr`, `Length` and the implicit `Result`, keep their names.
- **Case.** Free Pascal ignores the case of names and keywords, so Inspector writes them all in lower case. `Result := IntToStr(Year)` and `result := inttostr(year)` are the same. Strings keep their case.
- **Compiler directives.** Inspector drops compiler directives such as `{$mode ObjFPC}` and `{$H+}`, as Basic did, because a solution that passes its tests already compiles with them.
- **Imports.** Inspector drops every `uses` clause, because a solution that passes its tests has already loaded every unit it needs.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, `;` and the other punctuation, and brackets that only group, so `(a * b) + c` and `a * b + c` are the same.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, so `'it''s'` and `'it'#39's'` are the same, and so are `#65` and `'A'`. A string with a character code above 127, such as `#200`, keeps its text, because its value depends on the string type.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `$FF`, `%11111111`, `&377` and `255` are the same, and so are `1.50` and `1.5`. An integer and a real stay apart, so `1` and `1.0` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Free Pascal's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Free Pascal's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- The case of keywords and names: `BEGIN Result := X END` → `begin result := x end`.
- Quote style and character codes: `'it''s'` → `'it'#39's'`, `'a'#10'b'` → `'a'#$0A'b'`, and `#65` → `'A'`.
- Number spelling: `$FF` → `255`, `%11` → `3`, `&10` → `8` and `1.50` → `1.5`.
- A negative number and a minus sign before a number: `-1` → `- 1`.
- `otherwise` and `else` in a `case`: `case x of 1: a; otherwise b end` → `case x of 1: a; else b end`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- A `;` before `end`: `begin a; b; end` → `begin a; b end`.

## Analysis

This service doesn't make Free Pascal analyses yet, and Free Pascal had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, with Basic's rules for the track.
It now reads the solution's syntax tree, so it removes every comment and compiler directive wherever it is.
Its version is now 2.
