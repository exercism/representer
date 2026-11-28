# ReasonML's transition

This file says how the ReasonML outputs of this service differ from the tools they replace, and why.

## Representation

ReasonML had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Rosetta parses each solution with tree-sitter-reasonml instead, and writes the tree that Reason's parser would give.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears: values, functions, operators, parameters and their labels, the variables in patterns and loops, types, constructors, exceptions, record fields, type variables, modules, module types and functor parameters.
- **Layout.** Basic kept line breaks. Rosetta drops comments, layout, `;`, trailing commas, the `|` before the first constructor of a type, and brackets that only group, so `(a * b) / c` and `a * b / c` are the same, and so are `switch (x)` and `switch x`.
- **Imports.** The `open` statements are dropped, as Basic dropped them. A local open such as `List.(rev(xs))` stays, because it changes which names the code uses.
- **Functions and blocks.** Reason's parser reads `x => e` as `(x) => e`, `a => b => e` as `(a, b) => e`, and braces around one expression as the expression, so each pair is the same. The body of a `switch` case is read as a block too, so `| A => { 1 }` and `| A => 1` are the same.
- **Punning.** Reason's parser reads `~n` as `~n as n` in a parameter, `~n` as `~n=n` and `~n?` as `~n=?n` in an argument, and `{name}` as `{name: name}` in records and record patterns, so each pair is the same.
- **Pipes.** Reason's parser reads `->` as its older spelling `|.`, so `x->f` and `x |. f` are the same.
- **Strings.** Basic kept each string as written. Rosetta writes each string as its value, with its `\n`, `\t`, `\r`, `\b`, `\\`, `\"`, `\'` and `\ ` escapes read, so `{|say "hi"|}` and `"say \"hi\""` are the same. Any other escape stays as it is written. A `{j|...|j}` or `{js|...|js}` string keeps its delimiter, because BuckleScript reads those as Unicode strings and reads the `$` in a `{j|...|j}` string as a variable. A character keeps its text, so `'a'` and `"a"` stay apart.
- **Numbers.** Basic kept each number as written. Rosetta writes each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`, and `1.` and `1.0`. An integer stays apart from a float, and a number with a type suffix such as `10L` keeps its text.
- **Files.** Rosetta reads `.re` files, and ignores any `.rei` interface file.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with ReasonML's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Reason's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `{|you|}` → `"you"`.
- A backslash at the end of a line inside a string: `"a\` followed by a new line and `b"` → `"ab"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b101` → `5`, `1.` → `1.0`, `1.50` → `1.5` and `1e3` → `1000.`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, `g((x))` → `g(x)`, and `switch (x) {...}` → `switch x {...}`.
- A `|` before the first constructor: `type t = | A | B` → `type t = A | B`.
- A `;` or `,` after the last item: `[1, 2,]` → `[1, 2]`, and `{ a; b; }` → `{ a; b }`.
- A `;` after a statement at the end of a line: `let a = 1;` → `let a = 1`.
- One parameter without brackets: `x => x + 1` → `(x) => x + 1`.
- A function that returns a function: `a => b => a + b` → `(a, b) => a + b`.
- Braces around one expression: `x => { x + 1 }` → `x => x + 1`, and `| A => { 1 }` → `| A => 1`.
- A `switch` case with several statements: `| A => { g(x); 1 }` → `| A => g(x); 1`.
- A punned label or record field: `(~n) => n` → `(~n as n) => n`, `f(~n)` → `f(~n=n)`, `f(~n?)` → `f(~n=?n)`, and `{name}` → `{name: name}`.
- The fast pipe: `x->f` → `x |. f`.
- Spaces inside an operator in brackets: `( + )` → `(+)`.

## Analysis

This service doesn't make ReasonML analyses yet, and ReasonML had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to work on lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is, and skips the opens at the top of the file, up to the first other statement.
Its version is now 2.
