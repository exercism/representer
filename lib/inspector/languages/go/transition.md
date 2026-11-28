# Go's transition

This file says how the Go outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Go representer (`exercism/go-representer`), which parsed the solution with go/ast, rewrote it, and printed it as Go code.
It differs from the old representer in the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and in these ways:

- **Names.** The engine renames every name the solution defines, wherever it appears. The old representer renamed every name apart from Go's built-in names, the names of imported packages and their members, and a type written as the type of a parameter or field (`sound sound`). So a type now gets the same placeholder everywhere.
- **Imports.** The old representer kept every import. Inspector drops them, apart from an import of `_` (`import _ "embed"`), which runs the package's code.
- **Spellings.** The old representer printed strings, numbers and brackets as they were written. Inspector writes each string and number as its value, so `"a"` and `` `a` `` are the same, and so are `0x1F` and `31`. It also drops brackets that only group, and the package clause.
- **Order.** The old representer sorted the declarations at the top of the file by kind, and then by their length in the source, which depends on formatting. Inspector sorts them by their code, with the renamed names left out. Either way, two solutions that only order their declarations differently get the same representation.
- **Groups.** A group of types or variables at the top of the file (`type ( A int; B string )`) becomes one declaration for each. The old representer kept the group. A group of constants stays whole, because `iota` depends on it.
- **Local variables.** Inspector and the old representer both write a `var` inside a function as a `:=`. The old representer wrote the zero value of every type other than `int` and `string` as `T(0)`, so `var a bool` became `a := bool(0)`. It wrote the zero value of a slice, map, pointer or package type as the same text, so `var xs []int` and `var m map[string]bool` got the same representation. Inspector writes `false`, `0.0` and `0i` for `bool`, `float64` and `complex128`, and `T{}` for a struct or array type defined in the file or a standard library type such as `strings.Builder`. It keeps the `var` for any other type, and when `var a, b = 1, a` reads an outer `a`.
- **Values with a type.** The old representer dropped the type from `var x T = v`, unless `v` was a literal and `T` wasn't `string`, `int`, `float64`, `complex128` or `bool`. Inspector writes `T(v)`, unless `v` is already a literal of type `T` or a conversion to `T`, so `var a float64 = 1` is `a := float64(1)` and stays apart from `a := 1`. It keeps the `var` if `T` isn't a named type, as in `var m map[string]int = make(map[string]int)`.

## Spellings that share a representation

Go's parser reads each of these pairs as the same program, so Inspector gives them the same representation:

- Quote style: `` `a` `` → `"a"`, and `` `a\n` `` → `"a\\n"`.
- An escape and the character it stands for: `"\x41"` → `"A"`, `"\101"` → `"A"`, and `"\u00e9"` → `"é"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `017` → `15`, `0o17` → `15`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`, and `*(int)` → `*int`.
- A `;` between statements: `a := 1; g(a)` → the two statements on separate lines.
- A trailing comma after the last item: `[]int{1, 2,}` → `[]int{1, 2}`.
- A group of declarations: `var (` with `a = 1` and `b = 2` on their own lines → `var a = 1` and `var b = 2`, the same for `type`, and `import ("fmt")` → `import "fmt"`.

## Analysis

This service doesn't make Go analyses yet, so there is nothing to compare with the old analyzer (`exercism/go-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `package` and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the package clause and imports at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
