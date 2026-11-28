# VB.NET's transition

This file says how the VB.NET outputs of this service differ from the tools they replace, and why.

## Representation

VB.NET had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Inspector parses each solution with exercism/tree-sitter-vbnet instead, and writes the tree that VB.NET's own parser (Roslyn) would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: namespaces, modules, classes, structures, interfaces, enums and their members, delegates and type parameters, methods, properties and events, fields, local variables and parameters, the variables of `For`, `For Each` and `Catch`, the variables of queries, and labels.
- **Case.** VB.NET ignores the case of names and keywords, so Inspector writes every name in lower case, and every keyword in one spelling. `RETURN Total` and `return total` are the same. Strings keep their case.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, line continuations (` _`), `:` between statements, the `End` lines that close blocks, and brackets that only group, so `x = (a + b)` and `x = a + b` are the same.
- **Optional keywords.** VB.NET's parser reads some keywords as optional, so Inspector drops them: the `Then` of an `If`, the space in `Else If`, the `Case` of `Select Case`, and the variable after a loop's `Next`.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, and reads a doubled quote as one quote, so `"say ""hi"""` holds `say "hi"`. It reads typographic quotes as plain double quotes, and `{{` and `}}` in an interpolated string as braces. A character such as `"a"c` stays apart from the string `"a"`, because VB.NET gives them different types.
- **Numbers.** Basic kept each number as written. Inspector writes each number as its value, so `&H1F` and `31`, `1_000` and `1000`, and `.5` and `0.5` are the same. A floating-point number keeps its type character, so `8D` (a Decimal) stays apart from `8.0` (a Double).
- **Imports.** Inspector drops every `Imports` statement, because a solution that passes its tests has already made every namespace it needs available. Basic dropped them too.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with VB.NET's version. Every one of the 174 golden solutions parses.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

VB.NET's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Keyword case: `RETURN True` → `Return True`.
- Name case: `Total = SUM(Values)` → `total = sum(values)`.
- A name in square brackets: `[Select]` → `select`.
- `Then` after an `If` condition: `If a Then` → `If a`.
- `Else If` and `ElseIf`: `Else If a` → `ElseIf a`.
- `Select Case` and `Select`: `Select Case x` → `Select x`.
- The variable after `Next`: `Next i` → `Next`.
- The case of a number's letters: `&h1f` → `&H1F`, and `10l` → `10L`.
- A typographic quote and a plain double quote: `“a”` → `"a"`.
- Number spelling: `1_000` → `1000`, `&H1F` → `31`, `&B11` → `3`, `1.50` → `1.5`, `.5` → `0.5` and `1E3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.

## Analysis

This service doesn't make VB.NET analyses yet, and VB.NET had no analyzer, so there is nothing to compare.

## Snippet

The snippet works on the syntax tree, and removes every comment and the `Imports` statements at the top of the file. It gives the same snippet as before for every golden solution.
