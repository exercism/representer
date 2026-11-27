# Ruby's transition

This file says how the Ruby outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Ruby representer (`exercism/ruby-representer`).
It matches what the old representer did, apart from the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and these differences:

- The methods defined with `attr_reader`, `attr_writer` and `attr_accessor` keep their names. The old representer renamed them, but these are calls, and a call defines no name.
- Only the escapes used in the golden data are read (`\n`, `\t`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`). The old representer read every escape, so it merged `"\x41"` and `"A"`, which stay apart here.
- `|a,|` and `|a|` stay apart, because `|a,|` takes an array's first element. The old representer merged them, which was a bug.

## Analysis

This service doesn't make Ruby analyses yet, so there is nothing to compare with the old analyzer (`exercism/ruby-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `require` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `require` and `require_relative` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
