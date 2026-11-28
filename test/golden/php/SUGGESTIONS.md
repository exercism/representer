# Suggestions for PHP

[`transition.md`](../../../lib/inspector/languages/php/transition.md) says how Inspector differs from the old PHP representer.
These are changes that could improve it.
None of them is made, because a change to PHP's own behaviour needs the maintainers to decide it.

## Spellings that are apart today

1. **Write `TRUE`, `FALSE` and `NULL` in lower case.** PHP ignores the case of these constants, so `TRUE` and `true` are the same value.
2. **Read `elseif` as `else if`.** The two run the same way, and `else if` already gets the same representation as `else { if ... }`.
3. **Read `list($a, $b) = ...` as `[$a, $b] = ...`.** The two destructure an array the same way.
4. **Write each name given by `use` as its full name.** After `use A\B as C;`, `new C()` means `new A\B()`. The imports are dropped, so `new C()` and `new B()` stay apart today, although both can mean the same class.
5. **Read `var $x;` as `public $x;`.** PHP reads `var` as `public`.

## Names

6. **Rename the namespaces that the solution declares.** `namespace App;` keeps its name today, although the solution chose it.
7. **Treat every spelling of a function, method or class name as one name, across all the files.** Each file is normalised on its own today, so a function defined in one file and called from another with a capital letter in its name doesn't get its placeholder at the call. The engine would need to fold the case of these names when it renames.
