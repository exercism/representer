# Suggestions for ABAP

[`transition.md`](../../../lib/inspector/languages/abap/transition.md) says how Inspector treats ABAP differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to ABAP's own behaviour needs a human to decide it.
The counts come from a text search of the 400 golden solutions.

## Code that could be dropped

1. **Drop pragmas such as `##NEEDED`.** A pragma only turns off a warning from the syntax check or the code inspector, so it makes no difference to whether the solution works. 4 golden solutions use one.
2. **Drop the class's `FINAL` and `CREATE PUBLIC` options, and treat the `PUBLIC`, `PROTECTED` and `PRIVATE` sections as one.** The tests only call the public methods, so where a helper method or attribute is declared makes no difference to whether the solution works. 292 golden solutions have a `PRIVATE SECTION`.
3. **Drop `me->` before an attribute or method of the class itself.** `me->count` and `count` are the same attribute, unless a local variable has the same name. 11 golden solutions use `me->`.

## Spellings that are apart today

4. **Write `ADD 1 TO x` and `x = x + 1` as `x += 1`.** All three change `x` in the same way. 7 golden solutions use `ADD`, 48 use `+=`, and 72 use the long form.
5. **Write `'X'` as `abap_true`, and `' '` or `''` as `abap_false`.** `abap_true` is a constant with the value `'X'`, and `abap_false` is a blank. 42 golden solutions use `abap_true`, and 6 compare with `'X'`.
6. **Write `NOT x IS INITIAL` as `x IS NOT INITIAL`.** ABAP reads both as the same check. 21 golden solutions use `IS NOT INITIAL`.
7. **Write `ELSE. IF c. ... ENDIF. ENDIF.` as `ELSEIF c. ... ENDIF.`.** Both run the same code, but ABAP's parser reads the first as an `ELSE` block that holds an `IF`. 5 golden solutions have an `ELSE` followed straight away by an `IF`.
8. **Write `DATA x TYPE i. x = 1.` as `DATA(x) = 1.`, or the other way round.** Both declare a variable of the same type with the same value, when the value's type is the declared type. 195 golden solutions use an inline `DATA(...)`, and 127 use a `DATA` statement.
9. **Write `DATA x TYPE i VALUE 0.` as `DATA x TYPE i.`.** Every variable starts with its type's initial value, which is 0 for `i`. 9 golden solutions give an `i` variable the value 0.
10. **Write `VALUE ty_lines( ... )` as `VALUE #( ... )` where the type is known from the target.** Both build the same table. 73 golden solutions use `VALUE #(`.
11. **Write `CONCATENATE a b INTO c.` as `c = a && b.`, or as `c = |{ a }{ b }|.`.** All three join the same strings, apart from `CONCATENATE`'s handling of trailing blanks in text fields, so a rule would have to check the types. 14 golden solutions use `CONCATENATE`, 51 use `&&` and 77 use a string template with an embedded expression.
12. **Write a text literal's trailing spaces as nothing, where its type doesn't matter.** ABAP ignores the trailing blanks of a text field in most operations, so `'Group C-1 '` and `'Group C-1'` usually give the same result. They stay apart today, which splits one golden group in itab-basics. 2 golden solutions have a text literal that ends in a space.
13. **Write a single positional argument as the named argument it stands for.** ABAP reads `to_upper( s )` as `to_upper( val = s )`, and a method call with one argument as a call with its only importing parameter. 130 golden solutions call a built-in function such as `to_upper`, `strlen` or `condense` with a positional argument. A rule would have to know each method's parameters.
14. **Write `READ TABLE t ... TRANSPORTING NO FIELDS` followed by a check of `sy-subrc` as `line_exists( t[ ... ] )`.** Both test whether the table has the line. 20 golden solutions read a table and then check `sy-subrc`, and 2 use `line_exists`.

## Sorting

ABAP has no Reorder stage yet:

15. **Sort the methods in a class's DEFINITION, and the method implementations in its IMPLEMENTATION.** Their order makes no difference to the class. 146 golden solutions implement more than one method. The components of a structure must stay in order, because their order sets the structure's layout.

## The grammar

16. **Read a doubled quote inside a literal as one quote.** The grammar reads `'it''s'` as the literal `'it'` followed by the literal `'s'`, so the tree for such a statement has the wrong shape. No golden solution uses a doubled quote, so it makes no difference to the golden groups today. The same happens to a doubled backquote inside a string literal.
