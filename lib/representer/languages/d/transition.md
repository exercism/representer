# D's transition

This file says how the D outputs of this service differ from the tools they replace, and why.

## Representation

D had no representer of its own, so the track used Basic. Basic splits the code into tokens, drops the comments and the `import` lines, and keeps everything else as it is written, including the line breaks and the names.
D now has a representation of its own, which reads the solution's syntax tree and follows the decisions that apply to every language ([README.md](../../../../README.md#how-it-works) describes them).
These things change for D:

- **Names.** Basic renamed nothing. The representer renames every name the solution defines: its module, functions, types, enum members, constants, aliases, template parameters, variables, parameters (including those of function literals), `foreach` variables, caught exceptions and labels. A name the solution doesn't define, such as `writeln` or `length`, keeps its name.
- **Layout.** Basic kept the line breaks. The representer ignores all layout, so a brace on its own line makes no difference.
- **Brackets.** Brackets that only group make no difference, so `(year % 4 == 0) && b` and `year % 4 == 0 && b` are the same.
- **Imports.** As before, `import` declarations go, wherever they are.
- **Numbers.** Basic kept each number as written. The representer writes each integer that fits in an `int` and has no suffix as its value, so `1_000`, `0x3E8` and `1000` are the same. It writes each decimal without a suffix as its value, so `1.50` and `1.5` are the same. A number with a suffix, such as `10L` or `1.5f`, keeps its text.
- **Strings.** Basic kept each string as written. The representer writes each string as its value, so `` `a` ``, `r"a"`, `q{a}` and `"a"` are the same, and so are `"A"` and `"A"`. A string with a suffix, such as `"a"d`, keeps its text, because the suffix sets its type.
- **D's own equivalences.** D's parser reads `=> x` as `{ return x; }`, `x => x` as `(x) => x`, and `to!int` as `to!(int)`, so the representer gives each pair the same representation.
- **Errors.** A solution with a syntax error still gets Basic's representation, with D's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every D solution again.

## Analysis

This service doesn't make D analyses yet, and D had no analyzer before.

## Snippet

D's snippet hasn't changed. It still comes from Basic's snippet, which removes the comments found by Rouge's D lexer.
