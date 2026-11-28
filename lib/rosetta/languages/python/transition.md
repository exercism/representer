# Python's transition

This file says how the Python outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Python representer (`exercism/python-representer`), which renamed names in the tree from Python's own `ast` module, and left out docstrings, `print` statements, `if __name__ == "__main__":` blocks and type hints.
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these differences:

- `elif` and an `else` that holds only an `if` stay apart. Python's parser gives them the same tree, so the old representer merged them. A mentor would tell a student who writes the second to use `elif`, so iHiD decided to keep them apart.
- The name given with `as` in an import keeps its name, so `import numpy as np` and `import numpy as n` stay apart. The engine drops every import, so the alias is never defined. The old representer kept imports and renamed the alias.
- `from __future__` imports stay, because they change how Python reads the file. The engine drops every other import.
- `self` and Python's built-in names, such as `sum`, `list` and `next`, get placeholders when the solution defines them. The old representer kept them.
- Only the escapes `\n`, `\t`, `\r`, `\a`, `\b`, `\f`, `\v`, `\\`, `\'`, `\"` and a backslash before a line break are read. The old representer read every escape, so it merged `"\x41"` and `"A"`, which stay apart here.
- A decimal keeps every digit. Python rounds a float to 17 significant figures, so the old representer merged `77555998125.445779` and `77555998125.44579`.

## Spellings that share a representation

Python's parser reads each of these pairs as the same program, so Rosetta gives them the same representation:

- Quote style: `'you'` → `"you"`, and `'''you'''` → `'you'`.
- A raw string and its escaped spelling: `r"a\n"` → `"a\\n"`.
- An escape and the character it stands for: `'a\'b'` → `"a'b"`.
- The case of a string's prefix: `B"a"` → `b"a"`, and `F"{b}"` → `f"{b}"`.
- Strings written next to each other: `"a" "b"` → `"ab"`.
- Number spelling: `1_000` → `1000`, `0x1F` → `31`, `0o17` → `15`, `0b11` → `3`, `1.50` → `1.5`, `1e3` → `1000.0`, `2j` → `2.0j` and `1.5J` → `1.5j`.
- Brackets that only group: `(a * b) + c` → `a * b + c`.
- Brackets around a tuple: `a, b = x` → `(a, b) = x`, and `return a, b` → `return (a, b)`.
- Brackets around a generator that is a call's only argument: `sum((x for x in xs))` → `sum(x for x in xs)`.
- A list pattern and a tuple pattern in a `case`: `case [a, b]:` → `case (a, b):`.
- A trailing comma after the last item: `[1, 2,]` → `[1, 2]`, and `f(a, b,)` → `f(a, b)`.
- A `;` at the end of a statement: `x = 1;` → `x = 1`.
- A backslash that continues a line: `1 + \` and `2` on the next line → `1 + 2`.

## Analysis

This service doesn't make Python analyses yet, so there is nothing to compare with the old analyzer (`exercism/python-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, docstrings and `import` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment and docstring wherever they are, and skips the `import` and `from` statements at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
