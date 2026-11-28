# YAMLScript's transition

This file says how the YAMLScript outputs of this service differ from the tools they replace, and why.

## Representation

YAMLScript had no representer of its own, so the track used Basic, which writes a solution's tokens line by line and renames nothing.
Rosetta parses each solution with tree-sitter-yamlscript instead, and writes the forms that the YAMLScript compiler gives before it hands them to Clojure.
It makes the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and so it changes these things for the track:

- **Names.** Basic kept every name. Rosetta renames every name the solution defines, wherever it appears: functions, parameters, the variables of assignments, the names bound by `let`, `loop`, `for` and similar forms, and the names that a vector takes apart. The names that the solution doesn't define keep their names, such as `map` and `str/join`. A name inside an interpolated string keeps its text, because the grammar gives the string as one token.
- **Layout.** Basic kept line breaks and indentation. Rosetta drops comments, layout and brackets that only group an operator expression, so `(x % 4) == 0` and the same code over several lines are the same.
- **Calls.** A mapping pair, a call and a list are the same call, because the compiler turns each into the same Clojure form (see the list below).
- **Imports.** Every `use:` is dropped.
- **Strings.** Basic kept each string as written. Rosetta writes each string as its value, so `'a'` and `"a"` are the same. An interpolated string such as `"One for $name"` keeps its text and stays apart from the same text in single quotes, which doesn't interpolate.
- **Numbers.** Basic kept each number as written. Rosetta writes each number as its value, so `0.90` and `0.9` are the same, and `017` is the octal 15, as Clojure reads it. An integer stays apart from a decimal.
- **Files.** Rosetta reads `.ys` files.
- **Errors.** A solution that tree-sitter can't parse still gets Basic's representation, with YAMLScript's version.

The representation starts at version 6, one above Basic's version 5.

## Spellings that share a representation

The YAMLScript compiler turns each of these pairs into the same Clojure, so Rosetta gives them the same representation:

- The two version tags: `!YS-v0` and `!yamlscript/v0`.
- A mapping pair, a call and a list: `die: 'a'`, `die('a')` and `(die 'a')`, and `pow 2: x - 1` and `pow(2 (x - 1))`.
- A mapping below a key, whose pairs are the call's last arguments: `when x:` with `say: 'a'` on the next line, and `when(x say('a'))`.
- A `=>` key and its value: `=>: x` and `x`.
- A key that ends with an operator, and the operator between the key and the value: `(x > 1) ||:` with `die: 'a'` below it, and `(x > 1) || die('a')`.
- A value that starts with a method call, and the same call on the key: `uc(s):` with `.split()` below it, and `uc(s).split()`.
- A `_` in a key, and the value in its place: `filter _ xs: odd?` and `filter(odd? xs)`.
- The postfix operators and the methods they stand for: `x.#` and `x.count()`, `x.?` and `x.truey?()`, `x.!` and `x.falsey?()`, `x.++` and `x.inc()`, `x.--` and `x.dec()`, and `x.@` and `x.deref()`.
- A `:` call and a method call: `x:f` and `x.f()`.
- The words after a binding form, and one vector of them: `loop i 0:` and `loop [i 0]:`.
- The words after a test form, and one call of them: `when a b c:` and `when (a b c):`.
- The `then` and `else` of an `if`, and its branches: `if x:` with `then: 1` and `else: 2` below it, and `if x 1: 2`.
- The last clause of `cond`, `case`, `condp` and `condf`: `else:` and `=>:`, and in `cond`, `:else`.
- A chain of one operator, with or without brackets around it: `1 <= x <= 3` and `(1 <= x <= 3)`. A bracket inside the chain keeps its own expression, so `(a + b) + c` and `a + b + c` stay apart.
- Quote style: `'It''s'` and `"It's"`, and the escapes `\\`, `\"`, `\n` and `\t` and the characters they stand for.
- Number spelling: `0.90` and `0.9`, `1e3` and `1000.0`, and `017` and `15`.

## Analysis

This service doesn't make YAMLScript analyses yet, and YAMLScript had no analyzer, so there is nothing to compare.

## Snippet

The snippet used to apply its rules to lines, because the track had no grammar.
It now reads the solution's syntax tree, so it removes every comment wherever it is.
If a file doesn't parse, the snippet still finds the comments by the way they start (`#`).
The snippet's version is now 2.
