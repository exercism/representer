# WebAssembly's transition

This file says how the WebAssembly outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old WebAssembly representer (`exercism/wasm-representer`), which ran wabt's `wat-desugar` over every file and printed the result.
`wat-desugar` drops comments, writes folded instructions as plain instructions and writes each inline export as a separate export field, but it never renamed anything.
This representer gives one form to the same spellings, and differs from the old representer in the decisions that apply to every language, which [README.md](../../../../README.md#how-it-works) describes, and in these ways:

- **Names.** Every `$name` defined by the solution is renamed: functions, parameters, locals, globals, memories, tables, types, labels and so on. The old representer kept every name.
- **Exports.** An export is moved into the function, memory, global or table that it exports, so `(export "f" (func $f))` and `(func $f (export "f"))` are the same. `wat-desugar` did the opposite, and wrote each inline export as a separate field.
- **Function types.** A `(type (func ...))` without a name is dropped, if nothing refers to a type by its number. `wat-desugar` added such a field for each function's type.
- **Groups.** `(param i32 i32)` is the same as `(param i32) (param i32)`, and the same goes for results and locals.
- **Values.** Each string is written as its bytes, so `"\0a"` and `"\n"` are the same. Each number is written as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. A constant is written as its value in its type, so `f32.const 1` is `f32.const 1.0`, and `i32.const 4294967295` is `i32.const -1`.
- **Modules.** A file that holds a module's fields without the `(module ...)` around them gets the same representation as one with it.
- **Imports.** WebAssembly's `import` fields stay, because they say what the module needs from its host, beyond making names available.

## Analysis

This service doesn't make WebAssembly analyses yet.

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
This service reads the solution's syntax tree, so it removes every comment wherever it is.
If a file doesn't parse, it finds the comments by the `;;` at their start.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
