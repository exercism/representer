# ABAP's transition

This file says how the ABAP outputs of this service differ from the tools they replace, and why.

## Representation

ABAP had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The ABAP representer parses each solution with kennyhml/tree-sitter-abap instead, and writes the tree that the ABAP compiler's parser would give.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: classes, interfaces, methods, events and forms, parameters, types and structure components, variables, constants and field symbols, inline declarations such as `DATA(x)`, and the names given by `FOR`, `INDEX INTO`, `INIT`, `LET` and group keys.
- **Case.** ABAP ignores the case of names and keywords, so this representer writes them all in lower case. `IF Year MOD 4 = 0` and `if year mod 4 = 0` are the same. Strings keep their case.
- **Layout.** Basic kept line breaks. This representer drops comments (including ABAP Doc and pseudo-comments), layout, full stops, commas and brackets that only group, so `x = ( a + b ).` and `x = a + b.` are the same.
- **Spellings ABAP reads as one.** ABAP's parser reads a chained statement such as `DATA: a TYPE i, b TYPE i.` as one statement for each part, so it is the same as `DATA a TYPE i. DATA b TYPE i.`. It reads `EQ`, `NE`, `LT`, `GT`, `LE` and `GE` as `=`, `<>`, `<`, `>`, `<=` and `>=`, `!year` as `year`, and a method call with `EXPORTING` and only exported parameters as the same call without it. This representer gives each pair the same representation.
- **Strings.** Basic kept each string as written. This representer writes each literal and each string template's text as its value, and reads the escapes in string templates, so `|a\nb|` holds a line break. A text literal such as `'abc'` and a string literal such as `` `abc` `` stay apart, because ABAP gives them different types. A text literal keeps its trailing spaces.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `007` and `7` are the same.
- **Imports.** ABAP solutions have no imports, so nothing is dropped as one.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the ABAP representer's version. 24 of the 400 golden solutions don't parse.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make ABAP analyses yet, and ABAP had no analyzer, so there is nothing to compare.

## Snippet

The snippet still works on lines, with the same rules as before, so no snippet changes.
