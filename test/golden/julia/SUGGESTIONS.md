# Suggestions for Julia

[`transition.md`](../../../lib/inspector/languages/julia/transition.md) says how Inspector treats Julia differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Julia's own behaviour needs the maintainers to decide it.
The counts come from the 392 golden solutions.

## Code that could be dropped

1. **Drop docstrings.** A string before a definition, such as `"""Count the nucleotides."""`, only documents the code. 33 golden solutions have a triple-quoted string, mostly docstrings, and one production group splits because a docstring's blank lines hold a space. Python's snippet removes docstrings.
2. **Drop `export` and `public`.** `export f, g` only lists the names that `using` makes available. A solution that passes its tests exports what the tests need. Python drops `__all__` for the same reason.
3. **Drop the module around the solution.** `module Leap ... end` only names the namespace that the tests load with `using .Leap`. Java drops its package declaration.
4. **Drop the `return` of a function's last expression.** `function f(x) return x + 1 end` and `function f(x) x + 1 end` return the same value.
5. **Drop type annotations on parameters and return values.** `f(x::Int)` and `f(x)` behave the same for a solution that passes its tests, unless the solution defines several methods for one function and relies on dispatch. This needs care for that reason.
6. **Drop the `Base.` before a function that a solution extends.** `Base.show(io::IO, c::Clock)` and `show(io::IO, c::Clock)` after `import Base: show` define the same method. Today the first keeps `show` and the second renames it.

## Spellings that are apart today

7. **Write a short function and a `function` block the same way.** `f(x) = x + 1` and `function f(x) x + 1 end` define the same method. Julia's parser gives them different heads (`=` and `function`), so they stay apart today.
8. **Write an anonymous function the same way in every spelling.** `x -> x + 1` and `function (x) x + 1 end` make the same function.
9. **Write `if` and a ternary the same way.** `a ? b : c` and `if a b else c end` give the same value.
10. **Write a `do` block and an anonymous function argument the same way.** `map(xs) do x x * 2 end` and `map(x -> x * 2, xs)` make the same call.
11. **Write keyword arguments in a call the same way.** In a call, `f(a; b = 1)` and `f(a, b = 1)` pass `b` as a keyword either way. In a function's signature they differ, so this would apply only to calls.
12. **Write `isa(x, T)` and `x isa T` the same way**, and the same for other operators called as functions, such as `+(a, b)` and `a + b`.
13. **Read triple-quoted strings over several lines as Julia does.** Julia removes the first line break and the indentation that every line shares. With that, the docstrings in the golden data would compare by their text alone.

## Names

14. **Rename the alias of an import.** `import LinearAlgebra as LA` defines `LA`, but the engine drops the import before it renames, so `LA` keeps its name.
15. **Keep the names of functions that extend `Base`.** After `import Base: show`, a solution's `show` adds a method to the library's function. It could keep its name, as `Base.show` does.

## Sorting

Julia has no Reorder stage yet:

16. **Sort the top-level functions.** Their order makes no difference to what a solution does, because Julia looks up each function when a call runs. Constants and structs would keep their order, because code can use them only after they are defined.
17. **Sort the methods of one function by their signatures.** Dispatch picks a method by the types of its arguments, wherever it is in the file.
