# Pharo Smalltalk's transition

This file says how the Pharo Smalltalk outputs of this service differ from the tools they replace, and why.

## Representation

The track used Basic before, which writes a solution's tokens line by line and renames nothing.
Rosetta parses each Tonel file with tree-sitter-pharo-smalltalk instead, and writes the tree that Pharo's own parser gives, where each message has one selector such as `at:put:`.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears: the classes and traits named in a `Class { }` or `Trait { }` header, the instance variables, class variables and class instance variables declared there, the selectors of the methods (a keyword selector such as `at:put:` is one name), the parameters and temporaries of methods, and the parameters of blocks. Rosetta renames by text, so a symbol such as `#move` gets the same placeholder as a method called `move`. The names that the solution doesn't define keep their names, such as `Object`, `inject:into:` and `asUppercase`, and so does the class named in an `Extension { }` header. A binary selector such as `+` keeps its name, even if the solution defines a method with it.
- **Layout.** Basic kept line breaks and the spaces between tokens. Rosetta drops comments and layout.
- **Imports.** Smalltalk has no imports, so there is nothing to drop.
- **Strings and symbols.** Rosetta writes each string as its value, reading `''` as one quote. It writes each symbol as `#` and its value.
- **Numbers.** Rosetta writes each integer and each decimal as its value, as Pharo reads it: `16rFF` and `255` are the same, and so are `1.50` and `1.5`. An integer and a float stay apart, so `1` and `1.0` stay apart. A number with an exponent and no point, such as `1e10`, and a scaled decimal, such as `1.5s2`, keep their text.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with Pharo Smalltalk's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

Pharo's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Brackets that only group: `(a foo) bar` → `a foo bar`.
- Several `.` between statements, or one after the last statement: `a foo.. ^ b.` → `a foo. ^ b`.
- A trailing `,` in a class header or method category: `{ #name : #Foo, }` → `{ #name : #Foo }`.
- A symbol in quotes and the same symbol without them: `#'foo'` → `#foo`, and `#name : #'Foo'` → `#name : #Foo`.
- A word in a literal array and the same word as a symbol: `#(foo at:put: +)` → `#(#foo #at:put: #+)`.
- A nested array in a literal array, with or without its `#`: `#((1 2))` → `#(#(1 2))`.
- Number spelling: `16rFF` → `255`, `2r1010` → `10` and `1.50` → `1.5`.

## Analysis

This service doesn't make Pharo Smalltalk analyses yet, and Pharo Smalltalk had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to be Basic's, which removed the comments found by the track's Rouge lexer.
It now reads the solution's syntax tree, so it removes every comment wherever it is.
Its version is now 2.
