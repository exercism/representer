# Suggestions for Perl

These are improvements to Perl's representation for the maintainers to discuss.
None of them is in Inspector yet.

- **The version line.** `use v5.38` and `use v5.40` stay apart, and a solution with a version line stays apart from one with `use strict; use warnings;`. Both turn on strict and warnings, and the newer versions also turn on features such as `say` and signatures. A passing solution only uses the features it turned on, so dropping these lines would group solutions that differ only in them. A mentor might still comment on an old version line.
- **The `1;` at the end of a module.** A solution that ends with `1;` stays apart from one that doesn't. Perl needs the `1;` unless the solution has `use v5.37` or later, so dropping a final `1;` would group them.
- **Signatures and `@_`.** `sub f ($x) { ... }` stays apart from `sub f { my ($x) = @_; ... }` and from `sub f { my $x = shift; ... }`. They read the same argument, but a mentor might well comment on the choice.
- **Postfix conditions and loops.** `return 1 if $x;` stays apart from `if ($x) { return 1 }`, `unless ($x)` stays apart from `if (!$x)`, and `say for @list` stays apart from `for (@list) { say }`. Writing each pair the same way would group them.
- **A final `return`.** `sub f { return $x }` stays apart from `sub f { $x }`. Perl returns the value of the last statement, so dropping a final `return` would group them.
- **Low and high precedence operators.** `and`, `or` and `not` stay apart from `&&`, `||` and `!`, even where the precedence makes no difference.
- **Hash keys as names.** Hash keys keep their text, so `$self->{count}` and `$self->{total}` stay apart. Renaming the keys of the hashes the solution builds would group them, but keys often come from the exercise, such as the keys in the expected result.
- **Variables that aren't declared.** A solution without `use strict` can assign to a global without declaring it, such as `$count = 0`. These names keep their text. Renaming every variable that is assigned to would rename them too.
- **Names with a package.** `Leap::is_leap_year()` keeps its name even when the solution defines `is_leap_year`, and `sub Leap::is_leap_year` is renamed as a whole. Renaming the last part of such a name would group them with the plain spellings.
- **Exporter as a base class.** `our @ISA = ('Exporter')`, `use parent 'Exporter'` and `use base 'Exporter'` stay, although they only make `import` available, like `use Exporter 'import'`, which is dropped. Treating them as imports would group them.
- **Moose, Moo and other class modules.** `use Moo` is dropped like any other module, so a solution with `use Moo` and one with `use Moose` get the same representation if the rest is the same. A mentor might comment on the choice of module.
- **Other escapes.** Inspector reads `\n`, `\t`, `\r`, `\\`, `\"`, `\$` and `\@` in a double-quoted string. Other escapes keep their text, so `"\x41"` and `"A"`, and `"\e"` and `"\x1b"`, stay apart. Reading them too would make each pair the same.
- **Ranges without spaces.** The grammar reads `1..$n` as the number `1.` joined to `$n` with `.`, so `1..$n` stays apart from `1 .. $n`. A fix to the grammar would give them the same tree.
- **Dereferencing.** `@$list`, `@{$list}` and `$list->@*` stay apart, and so do `$$h{a}` and `$h->{a}`. Perl reads each group the same way, so writing them the same way would group them.
