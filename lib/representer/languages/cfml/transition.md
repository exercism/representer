# CFML's transition

This file says how the CFML outputs of this service differ from the tools they replace, and why.

## Representation

CFML had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
The CFML representer parses each solution with the CFScript grammar of tree-sitter-cfml instead, and writes the tree that a CFML engine's parser gives.
It makes the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. This representer renames every name the solution defines, wherever it appears: functions, parameters, variables (with or without `var`), the variables set on the `this`, `variables` and `local` scopes, and the variables of `for ... in` loops, closures and `catch`. Built-in functions, named arguments, attributes and types keep their names.
- **Case.** CFML ignores the case of names, keywords and operators, so this representer writes them all in lower case. `ArrayLen(Values)` and `arraylen(values)` are the same. Strings keep their case. The mapping gives each renamed name in lower case.
- **Layout.** Basic kept line breaks. This representer drops comments, layout, semicolons, stray `;` statements and brackets that only group.
- **Operators.** CFML's parser reads each word operator as its symbol, so `EQ`, `IS` and `==` are the same, and so are `NEQ`, `IS NOT`, `<>` and `!=`, `AND` and `&&`, `OR` and `||`, `NOT` and `!`, `MOD` and `%`, and `GT`, `GTE`, `LT`, `LTE` and their long forms and their symbols. `===` and `==` stay apart.
- **Structs.** The parser reads `{a = 1}` and `{a: 1}` as the same struct, so the two are the same. A quoted key stays apart from an unquoted one.
- **Other spellings.** `elseif` and `else if` are the same, and so are `x => x` and `(x) => x`, and `#x#` and `x` outside a string.
- **Imports.** Every `import` is dropped.
- **Strings.** Basic kept each string as written. This representer writes each string as its value, so `'a'` and `"a"` are the same. It reads a doubled quote as one quote and `##` as `#`. A string with an expression in it, such as `"#name#!"`, keeps the expression.
- **Numbers.** Basic kept each number as written. This representer writes each number as its value, so `010` and `10` are the same, and so are `1.50` and `1.5`. An integer stays apart from a decimal, so `1` and `1.0` stay apart.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with the CFML representer's version.

The representation starts at version 6, one above Basic's version 5.

## Analysis

This service doesn't make CFML analyses yet, and CFML had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the imports at the top of the file, up to the first other statement.
Its version is now 2.
