# Crystal's transition

This file says how the Crystal outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Crystal representer (`exercism/crystal-representer`), which parsed the solution with the Crystal compiler, renamed the names the solution defines, sorted the methods, and printed the tree back as Crystal code.
It differs from the old representer in the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and in these ways:

- **Imports.** The old representer kept each `require`. Rosetta drops them.
- **Spellings.** The old representer printed the code in the compiler's own layout. Rosetta writes each string as its value, keeping its interpolations, and each number as its value, so `1_000` and `1000` are the same, and so are `0x1F` and `31`. It drops a number's type suffix if it names the type the number has anyway, so `1_i32` is `1` and `2.0_f64` is `2.0`. It also drops brackets that only group, and the empty brackets of a call, so `f()` is `f`.
- **Accessors.** `getter :count` and `getter count` are the same here, and so are the `setter` and `property` forms. The old representer kept the symbol, so the two stayed apart.
- **Order.** Rosetta and the old representer both sort the methods inside each class, module and struct, and at the top of the file, and put them in the places where methods were. The old representer sorted them by their names before renaming them, so two solutions that named their methods differently could get different orders. Rosetta sorts them by their code, with the renamed names left out.
- **Names.** Rosetta and the old representer both rename the names the solution defines, wherever they appear, and give `@count`, `@@count` and `count` the same placeholder. Rosetta also renames the members of an enum, the type variables of a generic type (`T` in `class Box(T)`) and the type variables of `forall`, which the old representer kept.

## Spellings that share a representation

Crystal's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `%q(you)` → `"you"`, `%(a b)` → `"a b"`, and `%w(a b)` → `["a", "b"]`.
- An escape and the character it stands for: `"\x41"` → `"A"`, and `"\u{41}"` → `"A"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0b11` → `3`, `1.50` → `1.5` and `1e3` → `1000.0`.
- A suffix that names the number's default type: `1_i32` → `1`, and `2.0_f64` → `2.0`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around a call's arguments: `puts(x)` → `puts x`, and `f()` → `f`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `f(a, b,)` → `f(a, b)`.
- A `;` after a statement: `x = 1;` → `x = 1`.
- A modifier and its block: `puts 1 if a` → `if a; puts 1; end`, and the same for `unless`.
- Braces and `do ... end` around a block: `a.each { |x| p x }` → `a.each do |x| p x end`.
- `then` after `when`: `when 1 then y` → `when 1` with `y` on the next line.
- A quoted symbol: `:"abc"` → `:abc`.
- An operator called as a method: `y.**(2)` → `y ** 2`.

Rosetta also gives the same representation to an accessor's name written as a symbol or as a call: `getter :count` → `getter count`. Crystal's parser reads these differently, and the `getter` macro gives them the same meaning.

## Analysis

This service doesn't make Crystal analyses yet, so there is nothing to compare with the old analyzer (`exercism/crystal-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments and `require` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `require` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
