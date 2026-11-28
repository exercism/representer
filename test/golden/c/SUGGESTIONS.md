# Suggestions for C

[`transition.md`](../../../lib/rosetta/languages/c/transition.md) says how Rosetta treats C differently from Basic, which C used before.
These are changes that could improve it.
None of them is made, because a change to C's own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Put braces around the body of each `if`, `else` and loop.** `if (x) return 1;` and `if (x) { return 1; }` do the same, and C++ already treats them as one. The compiler gives them different trees, so they are apart today.
2. **Treat an include guard around a whole file as `#pragma once`, and drop both.** `#ifndef LEAP_H` / `#define LEAP_H` / `#endif` around a header only stops it being included twice, which can't change whether a passing solution works. 384 of the 390 headers in the golden data have a guard, and 6 use `#pragma once`, so a header with one and a header with the other are apart today. C++ already drops both.
3. **Write each spelling of a type the same way.** `unsigned` and `unsigned int`, `long` and `long int`, and `const int` and `int const` are the same type, but the grammar gives each spelling its own tree. In the golden data, 73 solutions write `unsigned int` and 76 write `unsigned` before another word.
4. **Read character literals as values.** `'A'`, `'\x41'` and `'\101'` are the same character, and only strings are read today.
5. **Write the suffixes of numbers in one case.** `10u` and `10U`, and `10l` and `10L`, are the same number of the same type, but a number with a suffix keeps its text today.
6. **Drop the code between `#if 0` and `#endif`.** The compiler never sees it, so it works like a comment. Two golden solutions have such a block.

## Names

7. **Parse the bodies of `#define`s, and rename the names in them and the macro's parameters.** The grammar gives a macro's body as text, so in `#define SQUARE(x) ((x) * (x))` the `x` in the body keeps its name, and `#define AREA (WIDTH * HEIGHT)` keeps `WIDTH` and `HEIGHT` although the solution defines them. 30 `#define`s in the golden data have a body with a name in it.

## Declarations

8. **Drop the declaration of a function that the solution also defines.** `bool leap_year(int year);` in the header says the same as the definition in the source file, so a solution that keeps the exercise's header and one that adds a helper's prototype to it are apart.

## Sorting

C has no Reorder stage:

9. **Sort the function definitions at the top level of a file.** The order of the functions makes no difference to what the code does, once each one is declared before it is called.
