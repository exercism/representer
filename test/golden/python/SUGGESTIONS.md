# Suggestions for Python

[`transition.md`](../../../lib/rosetta/languages/python/transition.md) says how Rosetta differs from the old Python representer.
These are changes that could improve it.
None of them is made, because a change to Python's own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Drop a stray `pass`.** A `pass` in a body that has other statements does nothing, but it keeps a solution apart from the same code without it. 7 golden solutions have one.
2. **Merge `u"a"` and `"a"`, and an f-string with no substitutions and a plain string.** Python's parser records the `u` prefix and the f-string, so they stay apart, although `u"a"` and `"a"` are the same string, and so are `f"a"` and `"a"`. No golden solution writes either.
3. **Read every escape.** Only the common escapes are read, so `"\x41"` and `"A"` stay apart. No golden solution writes `\x`, `\u`, `\N` or an octal escape.
4. **Rename the name given with `as` in an import.** The engine drops the import, so `import numpy as np` and `import numpy as n` stay apart. 4 golden solutions use `as`.
5. **Merge `from math import sqrt` with `import math`.** `sqrt(x)` and `math.sqrt(x)` call the same function, and a mentor would give the same feedback. 52 golden solutions use `from` imports and 43 use plain imports.

## Sorting

Python has no Reorder stage yet:

6. **Sort the functions and classes of a module, and the methods of a class.** Their order makes no difference to what the code does, as long as nothing at the top level calls a function before it is defined.
