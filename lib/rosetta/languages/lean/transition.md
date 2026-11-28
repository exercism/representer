# Lean's transition

This file says how the Lean outputs of this service differ from the tools they replace, and why.

## Representation

Lean had no representer of its own, so the track used Basic. Basic splits the code into tokens, drops the comments, and keeps everything else as it is written, including the line breaks, the indentation and the names.
Lean now has a representation of its own, which reads the solution's syntax tree with exercism/tree-sitter-lean4 and follows the decisions that apply to every language ([docs/how-it-works.md](../../../../docs/how-it-works.md) describes them).
These things change for Lean:

- **Names.** Basic renamed nothing. Rosetta renames every name the solution defines: its namespaces and sections, definitions, theorems and instances, `where` and `let` functions, parameters and binders, the variables in patterns, `let`, `have` and loop variables, the names of proofs such as `h` in `if h : i < n`, structures and their fields, inductive types and their constructors, and universes. A name the solution doesn't define, such as `List.map` or `Nat`, keeps its name. Rosetta splits a dotted name such as `xs.length` into its parts, and renames each part that the solution defines, so `xs` is renamed there too. If a solution implements a method of a library class in an instance, such as `toString`, that name is renamed everywhere. In a pattern, a name is a variable unless it is the function of an application, such as `some` in `some x`, a dotted name, or one of `none`, `true` and `false`, which are constructors in every file.
- **Tactic proofs and syntax quotations.** The grammar reads each tactic, such as `simp [helper]`, and each syntax quotation, such as `` `(x + 1) ``, as one token, and Rosetta keeps its text as it is written. So a name inside them keeps its spelling even when the solution defines it, and the spaces inside a tactic count. Two solutions that differ only in a name or spacing inside a proof or a quotation stay apart, so this can only cause missed merges. Thirteen golden solutions use `by` and three use syntax quotations, and none of their groups is split by this.
- **Layout.** Basic kept the line breaks and the indentation. Rosetta ignores all layout, so `;` is the same as a new line, and code on its own indented line is the same as code on the same line.
- **Comments.** As before, comments go, including `/-- -/` documentation.
- **Imports.** `import` lines go, and so do `open` lines, because a solution that passes its tests has already loaded what it needs, and an `open` only lets it use shorter names. Basic kept both.
- **Brackets.** Brackets that only group make no difference, so `(a % 4 == 0) && b` is the same as `a % 4 == 0 && b`, and `f (x)` is the same as `f x`. The brackets around a `·` function, such as `(· + 1)`, stay, because they mark where the function starts and ends.
- **Numbers.** Basic kept each number as written. Rosetta writes each number as its value, so `0x1F` and `31` are the same, and so are `1_000` and `1000`, and `1e3` and `1000.0`. `1` and `1.0` stay apart, because Lean reads `1.0` as a decimal.
- **Strings.** Basic kept each string as written. Rosetta writes each string as its value, with its `\n`, `\t`, `\\` and `\"` escapes read. Any other escape stays as it is written. An interpolated string keeps its `s!`, `f!` or `m!`, because each one gives a different type. A character keeps its quotes, so `'a'` and `"a"` stay apart.
- **Lean's own equivalences.** Lean's parser reads the spellings listed below as the same program, so each pair gets the same representation.
- **Errors.** A solution with a syntax error still gets Basic's representation, with Lean's version.

The representation's version is 6, one above Basic's version 5, so the website will represent every Lean solution again.

## Spellings that share a representation

Lean's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Unicode and ASCII spellings of the same token: `λ x ↦ x` → `fun x => x`, `x ← f` → `x <- f`, `Nat → Nat` → `Nat -> Nat`, `∀ n, p n` → `forall n, p n`, `∃ n, p n` → `exists n, p n`, `⦃α⦄` → `{{α}}` and `(· + 1)` → `(. + 1)`.
- A block of one statement on its own line: `def f :=\n  x` → `def f := x`, and `by\n  omega` → `by omega`.
- `;` in place of a new line: `do a; b` → `a` and `b` on separate lines.
- `where` after `inductive`: `inductive Color where | red` → `inductive Color | red`.
- The `end` lines at the end of the file: `namespace Leap\ndef f := 1\nend Leap` → `namespace Leap\ndef f := 1`, because Lean closes every namespace and section at the end of the file.
- Number spelling: `1_000` → `1000`, `0x1F` → `31` and `1e3` → `1000.0`.
- Brackets that only group: `(a % 4 == 0) && b` → `a % 4 == 0 && b`, and `f ((g x))` → `f (g x)`.

## Analysis

This service doesn't make Lean analyses yet, and Lean had no analyzer before.

## Snippet

The snippet is the same as before.
It works on lines, so that it can skip the `end` at the bottom of the file, and its version is still 1.
