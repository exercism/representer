# Pyret's transition

This file says how the Pyret outputs of this service differ from the tools they replace, and why.

## Representation

Pyret had no representer of its own, so the track used Basic, which drops comments and formatting and keeps everything else as tokens.
Inspector parses each solution with tree-sitter-pyret instead, and writes the tree that Pyret's own parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Inspector renames every name the solution defines, wherever it appears: functions, parameters, the names bound by `=`, `var`, `rec`, `for`, `cases` and tuple bindings, data types, their variants and fields, type parameters, type aliases, the keys of objects and methods, and the columns of tables. Names from Pyret's libraries, such as `num-modulo`, `map` and the keys of a `reactor`, keep their names.
- **Imports.** Inspector drops the `use context` line, every `provide`, `provide-types`, `include` and `import`. A solution that passes its tests has already loaded everything it needs, and provides everything the tests use, so these lines make no difference to it working. A name given by `import lists as L` keeps its name, so `L.map` stays as written.
- **Tests.** Inspector keeps the `check:`, `examples:` and `where:` blocks. Pyret runs them only when it checks the module, so they make no difference to whether the solution works, but a mentor may comment on the tests a student wrote. [SUGGESTIONS.md](../../../../test/golden/pyret/SUGGESTIONS.md) suggests dropping them.
- **Layout.** Basic kept line breaks. Inspector drops comments, layout, a `,` or `;` after the last item, the `|` before the first variant of a data type, and brackets that only group, so `(a + b) + c` and `a + b + c` are the same. Pyret reads a chain of one operator from the left, and needs brackets to mix two operators, so `a + (b + c)` stays apart.
- **Strings.** Basic kept each string as written. Inspector writes each string as its value, with its `\n`, `\t`, `\r`, `\\`, `\"`, `\'` and `` \` `` escapes read, so `'a"b'` and `"a\"b"` are the same. Pyret strips the blanks at the start and end of a string in triple backticks. Any other escape, such as `A`, stays as it is written.
- **Numbers.** Basic kept each number as written. Pyret reads every number as an exact number, so Inspector writes each number as its value: `1.0` and `1` are the same, and so are `1e3` and `1000`, and `0.50` and `0.5`. A fraction such as `1/2` keeps its text, and a rough number such as `~0.5` stays apart from an exact one.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Pyret's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Pyret's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `'a'` → `"a"`, and ```` ```a``` ```` → `"a"`.
- The blanks at the ends of a string in triple backticks: ```` ```  a  ``` ```` → `"a"`.
- Number spelling: `1.0` → `1`, `1e3` → `1000` and `0.50` → `0.5`.
- Brackets that only group: `(a + b) + c` → `a + b + c`, and `(f(x))` → `f(x)`.
- A `,` or `;` after the last item: `[list: 1, 2,]` → `[list: 1, 2]`, and `{1; 2;}` → `{1; 2}`.
- The `|` before the first variant: `data D: | a | b end` → `data D: a | b end`.
- A lambda in braces: `{(x): x * 2}` → `lam(x): x * 2 end`.

## Analysis

This service doesn't make Pyret analyses yet, and Pyret had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the `use context`, provides and imports at the top of the file, up to the first other statement.
Its version is now 2.
