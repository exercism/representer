# C++'s transition

This file says how the C++ outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old C++ representer (`exercism/cpp-representer`), which split the code into tokens with Pygments, dropped the comments, the preprocessor lines and the spacing, and renamed every name apart from the names after `std::`.
It differs from the old representer in the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and in these ways:

- **Syntax errors.** A solution with a syntax error gets Basic's representation, which only drops comments and formatting. The old representer worked on tokens, so it represented any text.
- **Preprocessor lines.** The old representer dropped every preprocessor line. This one drops `#include` and `#pragma` lines, and an `#ifndef` include guard around a whole file. It keeps `#define`s, because they change the code, and every other `#if`, `#ifdef` and `#ifndef`.
- **`using`.** The old representer kept `using namespace std;` and `using std::string;`. This one drops them outside classes, because they only make names available. A `using` in a class, such as `using Base::Base;`, stays.
- **Spellings.** The old representer kept every token as it was written. This one writes `and`, `or` and the other operator words as `&&`, `||` and so on, and `template <class T>` as `template <typename T>`. It puts braces around the body of each `if`, `else` and loop, so `else if` is `else { if ... }`. It writes each string as its value, joining strings written next to each other, and each integer that fits in an int and each decimal without a suffix as its value, so `1'000`, `0x3E8` and `1000` are the same.
- **Brackets and punctuation.** The tree shows what most keywords and punctuation said, so they are left out. The tokens that tell two programs apart stay, such as the `[]` of `delete[]` and the `class` of `enum class`. Brackets that only group stay, as they did before.

## Spellings that share a representation

The C++ compiler reads each of these pairs as the same program, so the representer gives them the same representation:

- The spelling of an integer that fits in an int and has no suffix: `0x1F` → `31`, `017` → `15`, `0b101` → `5` and `1'000` → `1000`.
- The spelling of a decimal without a suffix: `1.50` → `1.5`, and `1e3` → `1000.0`.
- An escape in a string and the character it stands for: `"a\x41"` → `"aA"`.
- A raw string and its escaped spelling: `R"(a\n)"` → `"a\\n"`.
- Strings written next to each other and the joined string: `"a" "b"` → `"ab"`.
- Operator words and their symbols: `a and not b` → `a && !b`, `a or b` → `a || b`, `a not_eq b` → `a != b`, `a xor b` → `a ^ b` and `a or_eq b` → `a |= b`.
- `class` and `typename` in a template parameter: `template <class T>` → `template <typename T>`.
- Braces around a single statement: `if (a) return 1;` → `if (a) { return 1; }`, and the same for `else`, `while`, `for`, a range `for` and `do`. `else if` is the same as `else { if ... }`.
- An include guard around the whole file and `#pragma once`: `#ifndef LEAP_H`, `#define LEAP_H` ... `#endif` → `#pragma once`.
- A trailing comma after the last item: `{1, 2,}` → `{1, 2}`, and `enum e { A, B, }` → `enum e { A, B }`.

## Analysis

This service doesn't make C++ analyses yet, so there is nothing to compare with the old analyzer (`exercism/cpp-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments, preprocessor lines and `using` lines by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment wherever it is, and skips the `#include`, `#pragma` and `using namespace` lines and the `namespace` line at the top of the file, up to the first other statement.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
