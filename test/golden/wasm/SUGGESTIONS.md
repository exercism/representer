# Suggestions for WebAssembly

[`transition.md`](../../../lib/inspector/languages/wasm/transition.md) says how Inspector differs from the old WebAssembly representer.
These are changes that could improve it.
None of them is made, because a change to WebAssembly's own behaviour needs the maintainers to decide it.

1. **Move exports into their definitions in a file without `(module ...)`.** A file can hold a module's fields without the `(module ...)` around them, but exports only move into their definitions, and function types without a name are only dropped, inside a `(module ...)`. So `(func $f) (export "f" (func $f))` and `(func $f (export "f"))` are apart in such a file, although they are the same inside a module.
2. **Read hexadecimal floats as values.** `f32.const 0x1p3` and `f32.const 8.0` are the same constant, and only decimal floats are read today.
3. **Read `nan` and `inf` in one form.** `f32.const nan` and `f32.const +nan` are the same constant.
