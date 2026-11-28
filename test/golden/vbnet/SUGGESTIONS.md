# Suggestions for VB.NET

[`transition.md`](../../../lib/inspector/languages/vbnet/transition.md) says how Inspector treats VB.NET differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to VB.NET's own behaviour needs a human to decide it.
The counts come from a search of the 174 golden solutions.

## Code that could be dropped

1. **Drop `ByVal`.** A parameter without `ByRef` is passed by value, so `ByVal x As Integer` and `x As Integer` work the same. Older versions of Visual Studio added `ByVal` to every parameter. 124 golden solutions use it, so this rule would merge the most solutions.
2. **Drop `Me.` before a member of the class itself.** `Me.count` and `count` are the same member, unless a local variable or parameter has the same name. The engine renames by name, so both would get the same placeholder anyway. C# drops `this.` in the same way. 18 golden solutions use `Me.`.
3. **Drop `Public` before a `Module`, and the other modifiers that make no difference to the tests.** The tests can call a module's public members whether or not the module itself is marked `Public`. 115 golden solutions write `Public Module`, and 11 write `Module`.
4. **Drop the empty brackets after `New`.** `New List(Of Integer)()` and `New List(Of Integer)` call the same constructor. 57 golden solutions create an object with empty brackets.
5. **Drop `Call`.** `Call F(x)` and `F(x)` run the same call. No golden solution uses `Call`.
6. **Drop `Option Strict`, `Option Explicit` and `Option Infer`.** They only change which code compiles, and every solution compiles. `Option Compare` must stay, because `Option Compare Text` changes how strings compare. No golden solution has an `Option` statement.

## Spellings that are apart today

7. **Write `Dim x As New Foo()` as `Dim x = New Foo()`, or the other way round.** Both declare a variable of type `Foo` and give it a new object. 46 golden solutions use `As New`, and 17 use `= New`.
8. **Write a single-line `If` as a block `If`.** `If a Then x = 1` and `If a Then` / `x = 1` / `End If` run the same code, but VB.NET's parser gives them different trees. 23 golden solutions use a single-line `If`.
9. **Write a call to a method without brackets as a call with empty brackets.** VB.NET lets a call with no arguments leave out its brackets, so `s.ToUpper` and `s.ToUpper()` are the same call. A rule would have to know which members are methods and which are properties.
10. **Write a floating-point number's type character in one form.** `1.5R` and `1.5#` are the same Double as `1.5`, `1.5!` is the same Single as `1.5F`, and `1.5@` is the same Decimal as `1.5D`. These stay apart today, which can only keep solutions apart. No golden solution uses `R`, `#`, `!` or `@`.
11. **Write `Case Is = 5` as `Case 5`.** Both match the same value. No golden solution uses `Case Is =`.
12. **Write `Order By x Ascending` as `Order By x`.** An ordering is ascending unless it says `Descending`. No golden solution uses `Ascending`.

## Names

13. **Rename the members of anonymous types.** `New With {.Total = x}` defines the member `Total`, but Inspector keeps its name today, because `.Total = x` in an object initializer such as `New Point With {.X = 1}` sets a member that the solution may not define.
14. **Read a name's type character as part of the declaration.** VB.NET reads `count%` and `count` as the same variable, but Inspector renames them as two names today.

