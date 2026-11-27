# Elixir's transition

This file says how the Elixir outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Elixir representer (`exercism/elixir-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- The name given with `as:` in `alias Foo.Bar, as: B` keeps its name. The engine drops every `alias`, so `B` is never defined. The old representer renamed it.
- `@type t(a) :: ...` and `@callback f(x) :: y` don't rename `t` and `f`, because only a type without parameters counts as a definition. The old representer renamed both.
- An attribute counts as defined only if the solution reads it, so that Elixir's own attributes (`@impl`, `@behaviour`, `@enforce_keys`) keep their names. The old representer kept a list of Elixir's attributes, and renamed every other one.

## Analysis

This service doesn't make Elixir analyses yet, so there is nothing to compare with the old analyzer (`exercism/elixir-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found `@moduledoc`, `@doc` and `@typedoc` by their text, with one rule for each way of quoting the docstring.
This service matches them as code in the solution's syntax tree, so it removes them however they are written, including `@doc false`.
It removes every comment wherever it is, and keeps the first 15 lines of the main file, where snippet-extractor kept 10.
