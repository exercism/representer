# Suggestions for C++

[`transition.md`](../../../lib/inspector/languages/cpp/transition.md) says how Inspector differs from the old C++ representer.
These are changes that could improve it.
None of them is made, because a change to C++'s own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Drop brackets that only group.** `(a % 4 == 0) && b` and `a % 4 == 0 && b` mean the same, and the tree's shape already shows the grouping. Most other languages drop these brackets.
2. **Read character literals as values.** `'A'`, `'\x41'` and `'\101'` are the same character, and only strings are read today.
3. **Write large integers as their values.** An integer too large for an int keeps its text, so `10'000'000'000` and `10000000000` are apart, although both are a `long`.
4. **Treat other include guards as `#pragma once`.** An `#if !defined(LEAP_H)` with a `#define LEAP_H` around a whole file does the same as an `#ifndef` guard, which is dropped. Most golden solutions have one in their header, because the exercise stubs do.
5. **Drop `std::` after `using namespace std;`.** In a solution with the `using`, `std::string` and `string` name the same type, and the engine drops the `using`.

## Names

6. **Rename the names of template parameters with a default, and of macro parameters.** `template <typename T = int>` defines `T`, and `#define SQUARE(x)` defines `x`, but neither counts as a definition today.

## Sorting

C++ has no Reorder stage:

7. **Sort the members of classes and structs.** The order of methods in a class makes no difference to what the code does.
