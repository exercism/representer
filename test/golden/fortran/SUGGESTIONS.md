# Suggestions for Fortran

[`transition.md`](../../../lib/inspector/languages/fortran/transition.md) says how Inspector treats Fortran differently from Basic, which the track used before.
These are changes that could improve it.
None of them is made, because a change to Fortran's own behaviour needs the maintainers to decide it.
The counts come from the 130 golden solutions.

## Spellings that Fortran's parser reads as the same

1. **Write a one-line `if` and an `if` block with one statement the same way.** A compiler reads `if (a) x = 1` and `if (a) then; x = 1; end if` as the same statement. Today the `then` keeps them apart, because mentors may point a student to the shorter form. 7 golden solutions use a one-line `if`.
2. **Write the length of a character variable one way.** `character(len=5)`, `character(5)` and `character*5` declare the same variable, and so do `character(len=*)` and `character(*)`. 37 golden solutions write `len=` and 48 leave it out.
3. **Write the kind of a number type one way.** `integer(kind=8)` and `integer(8)` declare the same type. 14 golden solutions give a kind without `kind=`, and none with it.
4. **Write a function's type one way.** `logical function f(x)` and a `function f(x)` that declares `logical :: f` define the same function. 52 golden solutions put the type before `function`.
5. **Write array declarations one way.** `integer, dimension(3) :: a` and `integer :: a(3)` declare the same array. 34 golden solutions use `dimension`.
6. **Read format strings without case.** Fortran reads `'(I0)'` and `'(i0)'` as the same format, but they are strings, so they keep their case. 6 golden solutions write a format with capitals.

## Equivalences for the maintainers to decide

7. **Write `result(r)` and assigning to the function's name the same way.** Both return the value, but they are different spellings, and mentors may comment on them. 63 golden solutions use `result`.
8. **Sort the declarations at the top of a procedure.** The order of declarations such as `integer :: i` and `logical :: q` makes no difference, unless one uses another, such as a constant used as an array size. Sorting would need care with those.
9. **Drop a bare `return` at the end of a procedure.** It changes nothing there. 36 golden solutions have a `return` on a line of its own, though some of these return early.
10. **Write `print *, x` and `write(*, *) x` the same way.** Both write the same output. Few solutions print anything: 2 golden solutions use `print`, and 9 use `write`, mostly to write into a string.

## Names

11. **Rename the variables of `do` and `forall` loops that have no declaration.** Without `implicit none`, a loop can use a variable that is never declared, and Inspector then keeps its name. 2 golden solutions leave out `implicit none`, and one of them uses an undeclared `forall` variable.
12. **Keep the names fixed by the tests.** The tests `use` the module by name and call its functions by name, so those names are the same in every solution, and renaming them only makes the output harder to read.
