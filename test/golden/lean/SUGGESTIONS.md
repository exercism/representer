# Suggestions for Lean

[`transition.md`](../../../lib/inspector/languages/lean/transition.md) says how Inspector treats Lean differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to Lean's own behaviour needs a human to decide it.
The counts come from the 121 golden solutions.

## Code that could be dropped

1. **Drop the `#eval`, `#check` and `#print` commands.** They only print while the file compiles, so they make no difference to whether the solution works. 3 golden solutions have one.
2. **Drop `private` and `protected`.** A helper's visibility makes no difference to whether the solution works. 17 golden solutions use one, so today `private def go` and `def go` stay apart.
3. **Drop `termination_by` and `decreasing_by`.** They only help the compiler prove that a function stops. 5 golden solutions use one.

## Spellings that are apart today

4. **Write `f $ x` and `f <| x` as `f x`.** All three apply `f` to `x`, and Lean turns `<|` into an application. 5 golden solutions use `$` and 3 use `<|`.
5. **Write `x |>.f a` as `x.f a`.** Lean reads `|>.` as a call of the field `f` on `x`. 18 golden solutions use `|>.`.
6. **Write `≤` and `≥` as `<=` and `>=`.** Lean's parser gives them different nodes, but both turn into `LE.le`. 17 golden solutions use the Unicode form and 11 the ASCII one.
7. **Write `return x` as `pure x` at the end of a `do` block.** At the end of a block, both give `x` as the result. 17 golden solutions use `return` and 5 use `pure`.
8. **Write a structure instance one way.** `{ x := a, y := b }`, `⟨a, b⟩` and `Point.mk a b` make the same value. Merging them needs the order of the structure's fields, which the solution may not define. 7 golden solutions use a structure instance with several fields and 9 use `⟨ ⟩`.
9. **Read the escapes in characters, and the other escapes in strings.** Inspector reads `\n`, `\t`, `\\` and `\"` in strings, and keeps characters as written. Reading `\r`, `\'`, `\x41` and `\u` escapes, and the escapes in characters such as `'\n'`, would make more literals the same. 2 golden solutions use an escape in a character.

## Names

10. **Rename the names inside tactic proofs.** The grammar reads each tactic as one token, so `simp [helper]` keeps the name `helper` when the solution defines it. Parsing tactics would let Inspector rename them, and would let it ignore the spaces inside a tactic. 13 golden solutions use `by`.
11. **Rename auto-bound type variables.** Lean binds a name such as `α` in `def f (xs : List α)` as an implicit argument, but Inspector only renames type variables that a binder such as `{α : Type}` declares. 5 golden solutions use `α` with a `List` or `Array`.
12. **Keep the names of library methods that a solution implements.** If a solution writes `instance : ToString Clock where toString c := ...`, Inspector renames `toString` everywhere, including the calls to `toString` on library types.
13. **Know the constructors opened with `open`.** After `open Nat`, a pattern `| zero => ...` names the constructor `Nat.zero`, but Inspector reads `zero` as a variable and renames it. Only `none`, `true` and `false` are read as constructors today. 1 golden solution matches on `zero` or `succ`.

## Sorting

Lean has no Reorder stage yet:

14. **Sort the fields of a structure instance.** `{ x := 1, y := 2 }` and `{ y := 2, x := 1 }` make the same value.
15. **Sort the classes in a `deriving` clause.** `deriving Repr, BEq` and `deriving BEq, Repr` derive the same instances. 31 golden declarations have a `deriving` clause.
