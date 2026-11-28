# Suggestions for OCaml

[`transition.md`](../../../lib/rosetta/languages/ocaml/transition.md) says how Rosetta treats OCaml differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to OCaml's own behaviour needs the maintainers to decide it.
The counts come from the 244 golden solutions.

## Spellings that OCaml's parser reads as the same

1. **Write a list as the conses it stands for.** OCaml's parser reads `[a; b]` as `a :: b :: []`, so the two are the same list. Mentors may still point a student to the shorter spelling. 4 golden solutions end a cons with `:: []`.
2. **Write `a.(i)` and `s.[i]` as the calls they stand for.** OCaml's parser reads `a.(i)` as `Array.get a i` and `s.[i]` as `String.get s i`, but the tree keeps the short spellings apart from the calls. 43 golden solutions use `.(` and 37 use `.[`.
3. **Write an operator in brackets and the same operator between its operands the same way.** OCaml's parser reads `( + ) a b` and `a + b` as the same application. Today only an operator in brackets without operands, as in `List.fold_left ( + ) 0`, is the operator itself. 9 golden solutions put an operator in brackets.
4. **Write a character as its value.** `'\n'` and `'\010'` are the same character, but each character keeps its text today.
5. **Write `let f x = e` and `let f = fun x -> e` the same way.** OCaml's parser gives both the same tree. No golden solution writes `let f = fun x ->`, and mentors do comment on it.

## Equivalences for the maintainers to decide

6. **Keep the names of labels.** A label such as `~width` comes from the exercise's interface, so it is the same in every solution, and renaming it only makes the output harder to read. Renaming also goes by text, so if a solution defines a label `~f`, every `~f:` passed to a library function such as `List.map` is renamed too. 87 golden solutions use labels.
7. **Rename the polymorphic variant tags the solution declares.** Today every tag keeps its name, like a value, because tags such as `` `A `` usually come from the exercise's interface and the tests compare against them. 27 golden solutions use tags.
8. **Drop type annotations.** `let area (r : float) : float = r *. r` and `let area r = r *. r` behave the same once the solution compiles. Mentors do sometimes comment on annotations. 42 golden solutions annotate a parameter.
9. **Treat `function` and `fun x -> match x with` the same.** `let f = function 0 -> 1 | _ -> 2` and `let f x = match x with 0 -> 1 | _ -> 2` do the same, but OCaml's parser gives them different trees. 95 golden solutions use `function` and 4 write `fun x -> match x with`.
10. **Write `x |> f` and `f @@ x` as `f x`.** All three apply `f` to `x`. Mentors do comment on pipelines, so this is a judgement call. 109 golden solutions use `|>` and 14 use `@@`.
11. **Drop the `_` at the end of a record pattern.** `{ name; _ }` and `{ name }` match the same records, and the `_` only turns off a warning. 6 golden solutions write it.
12. **Read the `.mli` file too.** Rosetta reads only `.ml` files, so two solutions that differ only in an interface file they submitted get the same representation. Reading `.mli` files needs tree-sitter-ocaml's interface grammar, which `grammars.yml` doesn't pin yet.
