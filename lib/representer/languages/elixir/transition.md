# Elixir's transition

This file says how the Elixir outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Elixir representer (`exercism/elixir-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these differences:

- The name given with `as:` in `alias Foo.Bar, as: B` keeps its name. The engine drops every `alias`, so `B` is never defined. The old representer renamed it.
- `@type t(a) :: ...` and `@callback f(x) :: y` don't rename `t` and `f`, because only a type without parameters counts as a definition. The old representer renamed both.
- An attribute counts as defined only if the solution reads it, so that Elixir's own attributes (`@impl`, `@behaviour`, `@enforce_keys`) keep their names. The old representer kept a list of Elixir's attributes, and renamed every other one.

## Spellings that share a representation

Elixir's parser reads each of these pairs as the same program, so the representer gives them the same representation:

- Quote style: a heredoc holding `a` and `b` on two lines → `"a\nb\n"`, and `:"abc"` → `:abc`.
- An escape and the character it stands for: `"a\sb"` → `"a b"`.
- A character and its code: `?a` → `97`.
- An empty charlist and an empty list: `''` → `[]`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b11` → `3`, `0o17` → `15`, `1.50` → `1.5` and `1.0e3` → `1000.0`.
- Brackets that only group: `(x * y) + 1` → `x * y + 1`.
- Brackets around a call's arguments: `String.upcase(x)` → `String.upcase x`, and `Mod.g()` → `Mod.g`.
- Empty brackets after a pipe: `x |> g` → `x |> g()`.
- Empty brackets after a type in `@spec` and `@type`: `integer()` → `integer`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`.
- A `;` between statements: `a = 1; a + x` → `a = 1` and `a + x` on two lines.
- The `do:` keyword and a `do` block: `def f(x), do: x + 1` → `def f(x) do x + 1 end`, and `if x, do: 1, else: 2` → `if x do 1 else 2 end`.
- Keyword lists and map keys: `[a: 1]` → `[{:a, 1}]`, `%{a: 1}` → `%{:a => 1}`, and `g(x, a: 1)` → `g(x, [a: 1])`.

## Analysis

This service doesn't make Elixir analyses yet, so there is nothing to compare with the old analyzer (`exercism/elixir-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found `@moduledoc`, `@doc` and `@typedoc` by their text, with one rule for each way of quoting the docstring.
This service matches them as code in the solution's syntax tree, so it removes them however they are written, including `@doc false`.
It removes every comment wherever it is, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
